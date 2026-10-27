% ==============================================================================
% INSTITUTO POLITÉCNICO NACIONAL - ESCUELA SUPERIOR DE CÓMPUTO (ESCOM)
% Unidad de Aprendizaje: Paradigmas de Programación
% Práctica Integradora 1er Parcial: Sistema Experto en Prolog
% Proyecto: PetMatch - Asistente Experto para la Elección y Adopción de Mascotas
% Integrantes: Diego Perea Medina y Cortés Cruz Gerardo
% Archivo: prolog/mascotas_kb.pl (Base de Conocimientos y Motor de Inferencia)
% ==============================================================================

:- module(mascotas_kb, [
    mascota/12,
    cuidados_especificos/2,
    rango_espacio/2,
    rango_tiempo/2,
    rango_experiencia/2,
    rango_presupuesto/2,
    compatible_espacio/2,
    compatible_tiempo/2,
    seguro_alergias/2,
    seguro_ninos/2,
    compatible_experiencia/2,
    compatible_presupuesto/2,
    compatible_especie/2,
    calcular_puntaje_afinidad/3,
    contar_elementos/2,
    clasificar_afinidad/2,
    explicacion_compatibilidad/8,
    recomendar_mascota/12,
    diagnosticar_descarte/9,
    obtener_recomendaciones/8
]).

% ------------------------------------------------------------------------------
% 1. HECHOS SIGNIFICATIVOS DEL DOMINIO (Base de Conocimientos)
% ------------------------------------------------------------------------------
% Predicado principal:
% mascota(ID, Nombre, Especie, CategoriaOrigen, Tamano, Energia,
%         EspacioMinimo, TiempoMinimo, Hipoalergenico, ToleranciaNinos,
%         ExperienciaRequerida, PresupuestoMensual).
%
% Valores de dominio:
% - Especie: perro | gato
% - CategoriaOrigen: raza | refugio
% - Tamano: pequeno | mediano | grande
% - Energia: baja | media | alta
% - EspacioMinimo: departamento_pequeno | departamento_amplio | casa_con_patio | casa_con_jardin_grande
% - TiempoMinimo: poco | moderado | alto
% - Hipoalergenico: si | no
% - ToleranciaNinos: alta | media | baja
% - ExperienciaRequerida: principiante | intermedio | avanzado
% - PresupuestoMensual: economico | moderado | alto

% --- Perros de Raza (9 hechos) ---
mascota(pug, 'Pug (Carlino)', perro, raza, pequeno, baja,
        departamento_pequeno, poco, no, alta, principiante, moderado).

mascota(chihuahua, 'Chihuahua', perro, raza, pequeno, media,
        departamento_pequeno, poco, no, baja, principiante, economico).

mascota(schnauzer_mini, 'Schnauzer Miniatura', perro, raza, pequeno, media,
        departamento_pequeno, moderado, si, alta, principiante, moderado).

mascota(poodle_estandar, 'Poodle (Caniche) Estándar', perro, raza, mediano, alta,
        departamento_amplio, moderado, si, alta, intermedio, alto).

mascota(bulldog_frances, 'Bulldog Francés', perro, raza, pequeno, baja,
        departamento_pequeno, poco, no, alta, principiante, alto).

mascota(beagle, 'Beagle', perro, raza, mediano, alta,
        casa_con_patio, moderado, no, alta, intermedio, moderado).

mascota(golden_retriever, 'Golden Retriever', perro, raza, grande, alta,
        casa_con_patio, alto, no, alta, principiante, alto).

mascota(border_collie, 'Border Collie', perro, raza, mediano, alta,
        casa_con_jardin_grande, alto, no, media, avanzado, moderado).

mascota(pastor_aleman, 'Pastor Alemán', perro, raza, grande, alta,
        casa_con_jardin_grande, alto, no, media, avanzado, alto).

% --- Gatos de Raza (7 hechos) ---
mascota(gato_persa, 'Gato Persa', gato, raza, pequeno, baja,
        departamento_pequeno, poco, no, media, intermedio, alto).

mascota(gato_siames, 'Gato Siamés', gato, raza, pequeno, media,
        departamento_pequeno, moderado, no, alta, principiante, moderado).

mascota(gato_azul_ruso, 'Gato Azul Ruso', gato, raza, pequeno, baja,
        departamento_pequeno, poco, si, media, principiante, moderado).

mascota(gato_siberiano, 'Gato Siberiano', gato, raza, mediano, media,
        departamento_amplio, moderado, si, alta, intermedio, alto).

mascota(gato_ragdoll, 'Gato Ragdoll', gato, raza, mediano, baja,
        departamento_pequeno, poco, no, alta, principiante, alto).

mascota(gato_bengali, 'Gato Bengalí', gato, raza, mediano, alta,
        departamento_amplio, alto, si, media, avanzado, alto).

mascota(gato_maine_coon, 'Gato Maine Coon', gato, raza, grande, media,
        departamento_amplio, moderado, no, alta, intermedio, alto).

% --- Perfiles de Animales de Refugio (8 hechos) ---
mascota(mestizo_adulto_tranquilo, 'Perro Mestizo Adulto Tranquilo (Refugio)', perro, refugio, mediano, baja,
        departamento_pequeno, poco, no, alta, principiante, economico).

mascota(mestizo_cachorro_activo, 'Cachorro Mestizo Juguetón (Refugio)', perro, refugio, mediano, alta,
        casa_con_patio, alto, no, alta, intermedio, economico).

mascota(mestizo_hipoalergenico, 'Cruza de Poodle Rescatado (Refugio)', perro, refugio, pequeno, media,
        departamento_pequeno, moderado, si, alta, principiante, economico).

mascota(perro_senior_refugio, 'Perro Senior Compañero (Refugio)', perro, refugio, mediano, baja,
        departamento_pequeno, poco, no, media, principiante, moderado).

mascota(mestizo_guardian_refugio, 'Mestizo Grande de Guardia y Pastoreo (Refugio)', perro, refugio, grande, alta,
        casa_con_jardin_grande, alto, no, baja, avanzado, moderado).

mascota(gato_comun_europeo, 'Gato Doméstico Pelo Corto Rescatado (Refugio)', gato, refugio, pequeno, media,
        departamento_pequeno, poco, no, alta, principiante, economico).

mascota(gato_senior_refugio, 'Gato Senior Tranquilo (Refugio)', gato, refugio, pequeno, baja,
        departamento_pequeno, poco, no, media, principiante, economico).

mascota(pareja_gatitos_refugio, 'Pareja de Gatitos Hermanos (Refugio)', gato, refugio, pequeno, alta,
        departamento_amplio, moderado, no, alta, intermedio, moderado).

% --- Hechos de Cuidados Específicos y Recomendaciones de Manejo (24 hechos) ---
cuidados_especificos(pug, [limpieza_pliegues_faciales, evitar_ golpes_de_calor, control_de_peso_estricto]).
cuidados_especificos(chihuahua, [socializacion_temprana, proteccion_contra_frio, cuidado_dental_frecuente]).
cuidados_especificos(schnauzer_mini, [cepillado_barba_y_pelo, corte_peluqueria_bimestral, paseos_con_estimulacion_mental]).
cuidados_especificos(poodle_estandar, [estetica_canina_mensual, juegos_de_inteligencia_diarios, ejercicio_aerobico_constante]).
cuidados_especificos(bulldog_frances, [ambiente_fresco_climatizado, limpieza_de_oidos_y_pliegues, seguro_o_fondo_veterinario]).
cuidados_especificos(beagle, [paseos_con_correa_por_instinto_olfativo, juguetes_interactivos_de_olfato, control_de_ladrido_y_ansiedad]).
cuidados_especificos(golden_retriever, [cepillado_frecuente_por_muda, ejercicio_intenso_y_juego_de_cobro, revision_articular_preventiva]).
cuidados_especificos(border_collie, [entrenamiento_agility_u_obediencia, alta_estimulacion_cognitiva_diaria, espacio_abierto_para_correr]).
cuidados_especificos(pastor_aleman, [adiestramiento_profesional_continuo, ejercicio_fisico_y_trabajo_diario, cuidado_preventivo_de_cadera]).
cuidados_especificos(gato_persa, [cepillado_diario_obligatorio, limpieza_lagrimal_diaria, ambiente_estrictamente_interior]).
cuidados_especificos(gato_siames, [interaccion_social_y_juego_diario, rascadores_altos, compania_frecuente_para_evitar_soledad]).
cuidados_especificos(gato_azul_ruso, [rutina_estable_y_tranquila, arenero_siempre_limpio, juguetes_de_caza_suave]).
cuidados_especificos(gato_siberiano, [cepillado_semanal_triple_capa, arbol_rascador_robusto, enriquecimiento_ambiental_vertical]).
cuidados_especificos(gato_ragdoll, [cepillado_suave_tres_veces_por_semana, estrictamente_interior, compania_afectuosa_constante]).
cuidados_especificos(gato_bengali, [circuitos_de_escalada_en_pared, sesiones_intensas_de_juego_interactivo, fuentes_de_agua_corriente]).
cuidados_especificos(gato_maine_coon, [arenero_y_rascador_extra_grandes, cepillado_frecuente, alimentacion_rica_en_proteina]).
cuidados_especificos(mestizo_adulto_tranquilo, [paseos_relajados_dos_veces_al_dia, periodo_de_adaptacion_paciente, chequeo_anual_y_desparasitacion]).
cuidados_especificos(mestizo_cachorro_activo, [educacion_positiva_y_uso_de_mordederas, esquema_completo_de_vacunacion, tres_paseos_diarios]).
cuidados_especificos(mestizo_hipoalergenico, [cepillado_semanal_para_evitar_nudos, bano_mensual_hipoalergenico, paseos_moderados_diarios]).
cuidados_especificos(perro_senior_refugio, [cama_ortopedica_accesible, paseos_cortos_a_su_ritmo, revision_veterinaria_semestral]).
cuidados_especificos(mestizo_guardian_refugio, [manejo_con_refuerzo_positivo_por_experto, barda_perimetral_segura, canalizacion_de_energia_diaria]).
cuidados_especificos(gato_comun_europeo, [enriquecimiento_con_rascadores, malla_de_proteccion_en_ventanas, esterilizacion_y_vacunacion_anual]).
cuidados_especificos(gato_senior_refugio, [arenero_de_borde_bajo, alimento_humedo_para_hidratacion, ambiente_calido_sin_estres]).
cuidados_especificos(pareja_gatitos_refugio, [dos_areneros_y_zona_de_juego, mallas_de_seguridad_en_ventanas, socializacion_y_esterilizacion_oportuna]).

% --- Hechos de Jerarquía Cuantitativa para Comparación Lógica ---
rango_espacio(departamento_pequeno, 1).
rango_espacio(departamento_amplio, 2).
rango_espacio(casa_con_patio, 3).
rango_espacio(casa_con_jardin_grande, 4).

rango_tiempo(poco, 1).
rango_tiempo(moderado, 2).
rango_tiempo(alto, 3).

rango_experiencia(principiante, 1).
rango_experiencia(intermedio, 2).
rango_experiencia(avanzado, 3).

rango_presupuesto(economico, 1).
rango_presupuesto(moderado, 2).
rango_presupuesto(alto, 3).

% ------------------------------------------------------------------------------
% 2. REGLAS LÓGICAS DE INFERENCIA Y PREDICADOS PROPIOS
% ------------------------------------------------------------------------------

% REGLA 1: Compatibilidad de Espacio Físico
% Una mascota es compatible con la vivienda del usuario si el nivel de espacio
% disponible del usuario es mayor o igual al espacio mínimo requerido por la mascota.
compatible_espacio(ViviendaUsuario, EspacioMinimoMascota) :-
    rango_espacio(ViviendaUsuario, NivelUsuario),
    rango_espacio(EspacioMinimoMascota, NivelMascota),
    NivelUsuario >= NivelMascota.

% REGLA 2: Compatibilidad de Tiempo Libre Diario
% El tiempo diario disponible del usuario debe cubrir al menos la demanda mínima
% de paseo, juego y atención de la mascota.
compatible_tiempo(TiempoUsuario, TiempoMinimoMascota) :-
    rango_tiempo(TiempoUsuario, NivelUsuario),
    rango_tiempo(TiempoMinimoMascota, NivelMascota),
    NivelUsuario >= NivelMascota.

% REGLA 3: Regla de Exclusión Estricta por Alergias en Casa
% Si en el hogar hay personas alérgicas (si), únicamente son seguras las mascotas
% hipoalergénicas (si). Si no hay alergias (no), cualquier mascota es segura.
seguro_alergias(no, _).
seguro_alergias(si, si).

% REGLA 4: Regla de Seguridad y Convivencia con Niños Pequeños
% - Si no hay niños en casa (ninguno), cualquier nivel de tolerancia es aceptable.
% - Si hay niños pequeños (< 6 años, pequenos), se exige tolerancia 'alta' estricta.
% - Si hay niños mayores (6 a 12 años, mayores), se acepta tolerancia 'alta' o 'media'.
seguro_ninos(ninguno, _).
seguro_ninos(pequenos, alta).
seguro_ninos(mayores, alta).
seguro_ninos(mayores, media).

% REGLA 5: Compatibilidad de Nivel de Experiencia del Adoptante
% El nivel de experiencia previa del adoptante debe ser mayor o igual al nivel
% de experiencia exigido por el temperamento y manejo de la mascota.
compatible_experiencia(ExperienciaUsuario, ExperienciaMascota) :-
    rango_experiencia(ExperienciaUsuario, NivelU),
    rango_experiencia(ExperienciaMascota, NivelM),
    NivelU >= NivelM.

% REGLA 6: Compatibilidad de Presupuesto Mensual de Mantenimiento
% El presupuesto mensual disponible del usuario debe cubrir al menos el costo
% estimado de alimentación, higiene y medicina preventiva de la mascota.
compatible_presupuesto(PresupuestoUsuario, PresupuestoMascota) :-
    rango_presupuesto(PresupuestoUsuario, NivelU),
    rango_presupuesto(PresupuestoMascota, NivelM),
    NivelU >= NivelM.

% REGLA 7: Filtro de Preferencia de Especie
% Permite unificar tanto con una especie específica ('perro' o 'gato') como con
% la opción abierta 'cualquiera' (demostrando polimorfismo y backtracking).
compatible_especie(cualquiera, _).
compatible_especie(EspeciePreferida, EspeciePreferida) :-
    EspeciePreferida \= cualquiera.

% REGLA 8: Recursividad sobre Listas - Conteo de Elementos (Cuidados)
% Predicado recursivo clásico para contar el número de cuidados específicos.
contar_elementos([], 0).
contar_elementos([_|Cola], Total) :-
    contar_elementos(Cola, SubTotal),
    Total is SubTotal + 1.

% REGLA 9: Recursividad sobre Listas - Cálculo Ponderado de Puntaje de Afinidad
% Calcula recursivamente la suma de puntos de una lista de factores de bonificación
% obtenidos durante la evaluación del perfil usuario-mascota.
sumar_factores([], 0).
sumar_factores([_-Puntos|Cola], Total) :-
    sumar_factores(Cola, SubTotal),
    Total is SubTotal + Puntos.

calcular_puntaje_afinidad(FactoresBonificacion, PuntajeBase, PuntajeFinal) :-
    sumar_factores(FactoresBonificacion, Bono),
    PuntajeSinTope is PuntajeBase + Bono,
    (PuntajeSinTope > 100 -> PuntajeFinal = 100 ; PuntajeFinal = PuntajeSinTope).

% REGLA 10: Generación de Factores de Bonificación según Holgura del Perfil
% Evalúa qué ventajas adicionales tiene el hogar del adoptante para una mascota compatible.
evaluar_factores_afinidad(ID, ViviendaU, TiempoU, NinosU, ExpU, PresupuestoU, Factores) :-
    mascota(ID, _, _, CategoriaOrigen, _, _, EspacioM, TiempoM, _, ToleranciaNinos, ExpM, PresupuestoM),
    rango_espacio(ViviendaU, NE_U), rango_espacio(EspacioM, NE_M),
    rango_tiempo(TiempoU, NT_U), rango_tiempo(TiempoM, NT_M),
    rango_experiencia(ExpU, NExp_U), rango_experiencia(ExpM, NExp_M),
    rango_presupuesto(PresupuestoU, NP_U), rango_presupuesto(PresupuestoM, NP_M),
    (NE_U > NE_M -> F1 = [espacio_extra_holgado-8] ; F1 = [espacio_exacto_requerido-4]),
    (NT_U > NT_M -> F2 = [tiempo_libre_sobrado-8] ; F2 = [tiempo_diario_adecuado-4]),
    (NExp_U > NExp_M -> F3 = [experiencia_superior-6] ; F3 = [experiencia_acorde-3]),
    (NP_U > NP_M -> F4 = [presupuesto_holgado-5] ; F4 = [presupuesto_ajustado-2]),
    (ToleranciaNinos == alta, NinosU \= ninguno -> F5 = [excelente_con_ninos-5] ; F5 = []),
    (CategoriaOrigen == refugio -> F6 = [impacto_adopcion_refugio-6] ; F6 = []),
    append([F1, F2, F3, F4, F5, F6], Factores).

% REGLA 11: Clasificación Cualitativa de la Recomendación (Inferencia de Conclusiones)
% Produce 3 niveles distintos de recomendación según el puntaje inferido.
clasificar_afinidad(Puntaje, compatibilidad_optima_ideal) :-
    Puntaje >= 90, !.
clasificar_afinidad(Puntaje, compatibilidad_alta_recomendada) :-
    Puntaje >= 80, Puntaje < 90, !.
clasificar_afinidad(_, compatibilidad_adecuada_viable).

% REGLA 12: Construcción de Explicación Lógica (Trazabilidad de Reglas Aplicadas)
explicacion_compatibilidad(ID, ViviendaU, TiempoU, AlergiasU, NinosU, ExpU, PresupuestoU, ReglasAplicadas) :-
    mascota(ID, _, _, CategoriaOrigen, _, _, EspacioM, TiempoM, HipoM, TolNinos, ExpM, PresupuestoM),
    Regla1 = regla_espacio(vivienda_usuario(ViviendaU), requiere_minimo(EspacioM)),
    Regla2 = regla_tiempo(tiempo_usuario(TiempoU), requiere_minimo(TiempoM)),
    Regla3 = regla_alergias(alergias_hogar(AlergiasU), mascota_hipoalergenica(HipoM)),
    Regla4 = regla_ninos(ninos_hogar(NinosU), tolerancia_mascota(TolNinos)),
    Regla5 = regla_experiencia(experiencia_usuario(ExpU), requiere_minimo(ExpM)),
    Regla6 = regla_presupuesto(presupuesto_usuario(PresupuestoU), costo_estimado(PresupuestoM)),
    Regla7 = regla_origen(modalidad(CategoriaOrigen)),
    ReglasAplicadas = [Regla1, Regla2, Regla3, Regla4, Regla5, Regla6, Regla7].

% REGLA 13: Predicado Principal de Recomendación Integral (Motor de Inferencia con Backtracking)
% Evalúa todas las restricciones lógicas, calcula el puntaje recursivo, clasifica la conclusión
% y recupera la lista de cuidados y la explicación de reglas aplicadas.
recomendar_mascota(ViviendaU, TiempoU, AlergiasU, NinosU, ExpU, PresupuestoU, EspeciePref,
                   ID, Nombre, Puntaje, NivelConclusion, Detalles) :-
    mascota(ID, Nombre, Especie, CategoriaOrigen, Tamano, Energia,
            EspacioM, TiempoM, HipoM, TolNinos, ExpM, PresupuestoM),
    compatible_especie(EspeciePref, Especie),
    compatible_espacio(ViviendaU, EspacioM),
    compatible_tiempo(TiempoU, TiempoM),
    seguro_alergias(AlergiasU, HipoM),
    seguro_ninos(NinosU, TolNinos),
    compatible_experiencia(ExpU, ExpM),
    compatible_presupuesto(PresupuestoU, PresupuestoM),
    evaluar_factores_afinidad(ID, ViviendaU, TiempoU, NinosU, ExpU, PresupuestoU, Factores),
    calcular_puntaje_afinidad(Factores, 70, Puntaje),
    clasificar_afinidad(Puntaje, NivelConclusion),
    cuidados_especificos(ID, ListaCuidados),
    contar_elementos(ListaCuidados, NumCuidados),
    explicacion_compatibilidad(ID, ViviendaU, TiempoU, AlergiasU, NinosU, ExpU, PresupuestoU, ReglasAplicadas),
    Detalles = detalles(
        especie(Especie),
        origen(CategoriaOrigen),
        tamano(Tamano),
        energia(Energia),
        hipoalergenico(HipoM),
        tolerancia_ninos(TolNinos),
        espacio_minimo(EspacioM),
        tiempo_minimo(TiempoM),
        experiencia_requerida(ExpM),
        presupuesto_estimado(PresupuestoM),
        cuidados(ListaCuidados),
        total_cuidados(NumCuidados),
        reglas(ReglasAplicadas)
    ).

% REGLA 14: Diagnóstico de Incompatibilidad (Explicación de por qué se descarta una mascota)
% Permite explicar al usuario qué reglas específicas fallaron para una mascota no recomendada.
diagnosticar_descarte(ViviendaU, TiempoU, AlergiasU, NinosU, ExpU, PresupuestoU, EspeciePref, ID, MotivosFallo) :-
    mascota(ID, _, Especie, _, _, _, EspacioM, TiempoM, HipoM, TolNinos, ExpM, PresupuestoM),
    (compatible_especie(EspeciePref, Especie) -> M0 = [] ; M0 = [especie_no_solicitada]),
    (compatible_espacio(ViviendaU, EspacioM) -> M1 = [] ; M1 = [espacio_insuficiente(requiere(EspacioM))]),
    (compatible_tiempo(TiempoU, TiempoM) -> M2 = [] ; M2 = [tiempo_insuficiente(requiere(TiempoM))]),
    (seguro_alergias(AlergiasU, HipoM) -> M3 = [] ; M3 = [riesgo_alergia_no_hipoalergenico]),
    (seguro_ninos(NinosU, TolNinos) -> M4 = [] ; M4 = [inseguro_para_ninos(tolerancia(TolNinos))]),
    (compatible_experiencia(ExpU, ExpM) -> M5 = [] ; M5 = [requiere_mayor_experiencia(ExpM)]),
    (compatible_presupuesto(PresupuestoU, PresupuestoM) -> M6 = [] ; M6 = [excede_presupuesto(requiere(PresupuestoM))]),
    append([M0, M1, M2, M3, M4, M5, M6], MotivosFallo),
    MotivosFallo \= [].

% REGLA 15: Recolección de todas las soluciones vía Backtracking (findall)
obtener_recomendaciones(ViviendaU, TiempoU, AlergiasU, NinosU, ExpU, PresupuestoU, EspeciePref, ListaSoluciones) :-
    findall(
        solucion(Puntaje, ID, Nombre, NivelConclusion, Detalles),
        recomendar_mascota(ViviendaU, TiempoU, AlergiasU, NinosU, ExpU, PresupuestoU, EspeciePref,
                           ID, Nombre, Puntaje, NivelConclusion, Detalles),
        SolucionesSinOrdenar
    ),
    sort(1, @>=, SolucionesSinOrdenar, ListaSoluciones).
