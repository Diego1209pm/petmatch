% ==============================================================================
% INSTITUTO POLITÉCNICO NACIONAL - ESCUELA SUPERIOR DE CÓMPUTO (ESCOM)
% Unidad de Aprendizaje: Paradigmas de Programación
% Proyecto: PetMatch - Servidor HTTP y API JSON conectado a SWI-Prolog
% Integrantes: Diego Perea Medina y Cortés Cruz Gerardo
% Archivo: prolog/server.pl
% ==============================================================================

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_parameters)).
:- use_module(mascotas_kb).

% Configuración de CORS para permitir peticiones desde cualquier origen
:- set_setting(http:cors, [*]).

% Definición de rutas HTTP
:- http_handler(root(.), servir_index, []).
:- http_handler(root('index.html'), servir_index, []).
:- http_handler(root('api/salud'), api_salud, [method(get)]).
:- http_handler(root('api/catalogo'), api_catalogo, [method(get)]).
:- http_handler(root('api/consultar'), api_consultar, [methods([post, options])]).

% Arranque del servidor en el puerto indicado por la variable de entorno PORT (default 8080)
iniciar_servidor :-
    (getenv('PORT', PuertoStr) -> atom_number(PuertoStr, Puerto) ; Puerto = 8080),
    http_server(http_dispatch, [port(Puerto)]),
    format('Servidor SWI-Prolog PetMatch escuchando en http://0.0.0.0:~w~n', [Puerto]),
    thread_get_message(stop).

% Servir interfaz gráfica principal
servir_index(Request) :-
    http_reply_file('frontend/index.html', [unsafe(true)], Request).

% Endpoint de estado de salud del motor Prolog
api_salud(_Request) :-
    cors_enable,
    findall(ID, mascota(ID, _, _, _, _, _, _, _, _, _, _, _), Lista),
    length(Lista, TotalMascotas),
    reply_json_dict(_{
        estado: "activo",
        motor: "SWI-Prolog",
        sistema: "PetMatch - Sistema Experto de Adopcion de Mascotas",
        hechos_mascotas_cargados: TotalMascotas
    }).

% Endpoint para listar el catálogo completo de hechos de mascotas en la base de conocimientos
api_catalogo(_Request) :-
    cors_enable,
    findall(
        _{
            id: ID,
            nombre: Nombre,
            especie: Especie,
            origen: Origen,
            tamano: Tamano,
            energia: Energia,
            espacio_minimo: EspacioM,
            tiempo_minimo: TiempoM,
            hipoalergenico: HipoM,
            tolerancia_ninos: TolNinos,
            experiencia_requerida: ExpM,
            presupuesto_mensual: PresupuestoM,
            cuidados: Cuidados
        },
        (
            mascota(ID, Nombre, Especie, Origen, Tamano, Energia, EspacioM, TiempoM, HipoM, TolNinos, ExpM, PresupuestoM),
            cuidados_especificos(ID, Cuidados)
        ),
        Catalogo
    ),
    reply_json_dict(_{total: Catalogo}).

% Validación de dominios permitidos (evita inyección de código Prolog arbitrario)
valor_valido(vivienda, V) :- member(V, [departamento_pequeno, departamento_amplio, casa_con_patio, casa_con_jardin_grande]).
valor_valido(tiempo, V) :- member(V, [poco, moderado, alto]).
valor_valido(alergias, V) :- member(V, [si, no]).
valor_valido(ninos, V) :- member(V, [ninguno, pequenos, mayores]).
valor_valido(experiencia, V) :- member(V, [principiante, intermedio, avanzado]).
valor_valido(presupuesto, V) :- member(V, [economico, moderado, alto]).
valor_valido(especie, V) :- member(V, [cualquiera, perro, gato]).

% Manejo de preflight OPTIONS para CORS
api_consultar(Request) :-
    member(method(options), Request), !,
    cors_enable(Request, [methods([get, post, options])]),
    format('~n').

% Procesamiento de consulta POST /api/consultar
api_consultar(Request) :-
    cors_enable(Request, [methods([get, post, options])]),
    catch(
        (
            http_read_json_dict(Request, DatosEntrada),
            procesar_consulta_json(DatosEntrada, RespuestaDict),
            reply_json_dict(RespuestaDict)
        ),
        Error,
        (
            message_to_string(Error, MensajeError),
            reply_json_dict(_{
                exito: false,
                error: "Error en el formato de la solicitud JSON o parametros faltantes.",
                detalle: MensajeError
            }, [status(400)])
        )
    ).

% Extracción y validación segura de parámetros antes de consultar al motor de inferencia
procesar_consulta_json(Dict, Respuesta) :-
    (   get_dict(vivienda, Dict, VivStr),
        get_dict(tiempo, Dict, TieStr),
        get_dict(alergias, Dict, AleStr),
        get_dict(ninos, Dict, NinStr),
        get_dict(experiencia, Dict, ExpStr),
        get_dict(presupuesto, Dict, PreStr),
        get_dict(especie, Dict, EspStr)
    ->  atom_string(Vivienda, VivStr),
        atom_string(Tiempo, TieStr),
        atom_string(Alergias, AleStr),
        atom_string(Ninos, NinStr),
        atom_string(Experiencia, ExpStr),
        atom_string(Presupuesto, PreStr),
        atom_string(Especie, EspStr),
        validar_y_ejecutar(Vivienda, Tiempo, Alergias, Ninos, Experiencia, Presupuesto, Especie, Respuesta)
    ;   Respuesta = _{
            exito: false,
            codigo: "DATOS_INCOMPLETOS",
            mensaje: "Datos incompletos: Debes proporcionar vivienda, tiempo, alergias, ninos, experiencia, presupuesto y especie."
        }
    ).

validar_y_ejecutar(Vivienda, Tiempo, Alergias, Ninos, Experiencia, Presupuesto, Especie, Respuesta) :-
    (   valor_valido(vivienda, Vivienda),
        valor_valido(tiempo, Tiempo),
        valor_valido(alergias, Alergias),
        valor_valido(ninos, Ninos),
        valor_valido(experiencia, Experiencia),
        valor_valido(presupuesto, Presupuesto),
        valor_valido(especie, Especie)
    ->  ejecutar_inferencia_prolog(Vivienda, Tiempo, Alergias, Ninos, Experiencia, Presupuesto, Especie, Respuesta)
    ;   Respuesta = _{
            exito: false,
            codigo: "VALORES_NO_VALIDOS",
            mensaje: "Uno o mas parametros contienen valores fuera del dominio permitido por la base de conocimientos."
        }
    ).

% Ejecución real del motor de inferencia y transformación de términos Prolog a JSON
ejecutar_inferencia_prolog(Vivienda, Tiempo, Alergias, Ninos, Experiencia, Presupuesto, Especie, Respuesta) :-
    obtener_recomendaciones(Vivienda, Tiempo, Alergias, Ninos, Experiencia, Presupuesto, Especie, SolucionesRaw),
    maplist(solucion_a_dict, SolucionesRaw, SolucionesJSON),
    length(SolucionesJSON, TotalSoluciones),
    findall(
        _{id: IDDesc, nombre: NomDesc, motivos: MotivosTexto},
        (
            mascota(IDDesc, NomDesc, _, _, _, _, _, _, _, _, _, _),
            diagnosticar_descarte(Vivienda, Tiempo, Alergias, Ninos, Experiencia, Presupuesto, Especie, IDDesc, MotivosTerm),
            maplist(term_string, MotivosTerm, MotivosTexto)
        ),
        DescartadosJSON
    ),
    format(string(ConsultaPrologStr),
           "obtener_recomendaciones(~w, ~w, ~w, ~w, ~w, ~w, ~w, Soluciones).",
           [Vivienda, Tiempo, Alergias, Ninos, Experiencia, Presupuesto, Especie]),
    (   TotalSoluciones > 0
    ->  Mensaje = "Inferencia completada con exito mediante backtracking en SWI-Prolog."
    ;   Mensaje = "No se encontraron mascotas que cumplan simultaneamente todas las restricciones lógicas ingresadas."
    ),
    Respuesta = _{
        exito: true,
        consulta_prolog: ConsultaPrologStr,
        total_soluciones: TotalSoluciones,
        mensaje: Mensaje,
        recomendaciones: SolucionesJSON,
        descartados: DescartadosJSON
    }.

solucion_a_dict(solucion(Puntaje, ID, Nombre, NivelConclusion, Detalles), Dict) :-
    Detalles = detalles(
        especie(Especie),
        origen(Origen),
        tamano(Tamano),
        energia(Energia),
        hipoalergenico(Hipo),
        tolerancia_ninos(TolNinos),
        espacio_minimo(EspacioM),
        tiempo_minimo(TiempoM),
        experiencia_requerida(ExpM),
        presupuesto_estimado(PresupuestoM),
        cuidados(ListaCuidados),
        total_cuidados(NumCuidados),
        reglas(ReglasTerm)
    ),
    maplist(term_string, ReglasTerm, ReglasStr),
    Dict = _{
        id: ID,
        nombre: Nombre,
        puntaje_afinidad: Puntaje,
        conclusion: NivelConclusion,
        especie: Especie,
        origen: Origen,
        tamano: Tamano,
        energia: Energia,
        hipoalergenico: Hipo,
        tolerancia_ninos: TolNinos,
        espacio_minimo: EspacioM,
        tiempo_minimo: TiempoM,
        experiencia_requerida: ExpM,
        presupuesto_estimado: PresupuestoM,
        cuidados_especificos: ListaCuidados,
        total_cuidados: NumCuidados,
        reglas_aplicadas: ReglasStr
    }.
