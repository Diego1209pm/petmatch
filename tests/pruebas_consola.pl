% ==============================================================================
% INSTITUTO POLITÉCNICO NACIONAL - ESCUELA SUPERIOR DE CÓMPUTO (ESCOM)
% Unidad de Aprendizaje: Paradigmas de Programación
% Archivo: tests/pruebas_consola.pl
% Descripción: Batería de 12 Casos de Prueba Documentados para ejecutar en SWI-Prolog
% ==============================================================================

:- use_module('../prolog/mascotas_kb').

ejecutar_todas_las_pruebas :-
    writeln('===================================================================='),
    writeln(' BATERIA DE 12 CASOS DE PRUEBA - SISTEMA EXPERTO PETMATCH (PROLOG)'),
    writeln('===================================================================='),
    prueba_1,
    prueba_2,
    prueba_3,
    prueba_4,
    prueba_5,
    prueba_6,
    prueba_7,
    prueba_8,
    prueba_9,
    prueba_10,
    prueba_11,
    prueba_12,
    writeln('===================================================================='),
    writeln(' TODAS LAS PRUEBAS FINALIZARON CORRECTAMENTE'),
    writeln('====================================================================').

% Caso 1: Consulta de apartamento pequeño, poco tiempo, con alergias, sin niños, principiante, presupuesto moderado
prueba_1 :-
    writeln('\n[CASO 1] Depto pequeno + poco tiempo + ALERGIAS (si) + principiante + moderado:'),
    obtener_recomendaciones(departamento_pequeno, poco, si, ninguno, principiante, moderado, cualquiera, Sols),
    mostrar_resumen(Sols).

% Caso 2: Familia con niños pequeños en casa con patio, tiempo alto, sin alergias, principiante, presupuesto alto
prueba_2 :-
    writeln('\n[CASO 2] Casa con patio + tiempo alto + NINOS PEQUENOS + principiante + presupuesto alto (Solo Perros):'),
    obtener_recomendaciones(casa_con_patio, alto, no, pequenos, principiante, alto, perro, Sols),
    mostrar_resumen(Sols).

% Caso 3: Adoptante experto con jardín grande, busca perro de alta energía con presupuesto moderado
prueba_3 :-
    writeln('\n[CASO 3] Casa con jardin grande + tiempo alto + sin alergias + sin ninos + AVANZADO + moderado:'),
    obtener_recomendaciones(casa_con_jardin_grande, alto, no, ninguno, avanzado, moderado, perro, Sols),
    mostrar_resumen(Sols).

% Caso 4: Estudiante con presupuesto económico en departamento pequeño y poco tiempo libre
prueba_4 :-
    writeln('\n[CASO 4] Depto pequeno + poco tiempo + sin alergias + sin ninos + principiante + ECONOMICO:'),
    obtener_recomendaciones(departamento_pequeno, poco, no, ninguno, principiante, economico, cualquiera, Sols),
    mostrar_resumen(Sols).

% Caso 5: Familia con alergias y niños pequeños en departamento amplio y presupuesto moderado
prueba_5 :-
    writeln('\n[CASO 5] Depto amplio + tiempo moderado + ALERGIAS (si) + NINOS PEQUENOS + principiante + moderado:'),
    obtener_recomendaciones(departamento_amplio, moderado, si, pequenos, principiante, moderado, cualquiera, Sols),
    mostrar_resumen(Sols).

% Caso 6: Amante de los gatos con experiencia intermedia, departamento amplio y presupuesto alto
prueba_6 :-
    writeln('\n[CASO 6] Depto amplio + tiempo moderado + sin alergias + ninos mayores + intermedio + alto (Solo Gatos):'),
    obtener_recomendaciones(departamento_amplio, moderado, no, mayores, intermedio, alto, gato, Sols),
    mostrar_resumen(Sols).

% Caso 7: Consulta sin coincidencias (Restricciones incompatibles: depto pequeño + poco tiempo + alergias + niños pequeños + económico)
prueba_7 :-
    writeln('\n[CASO 7 - SIN COINCIDENCIAS] Depto pequeno + poco tiempo + alergias(si) + ninos(pequenos) + economico:'),
    obtener_recomendaciones(departamento_pequeno, poco, si, pequenos, principiante, economico, cualquiera, Sols),
    mostrar_resumen(Sols).

% Caso 8: Prueba directa de exclusión lógica (Negación / Falso esperado): ¿Es el Chihuahua seguro para niños pequeños?
prueba_8 :-
    writeln('\n[CASO 8 - PRUEBA NEGATIVA] ¿Es el Chihuahua (tolerancia baja) seguro para ninos pequenos?'),
    mascota(chihuahua, _, _, _, _, _, _, _, _, Tol, _, _),
    (seguro_ninos(pequenos, Tol) -> writeln('  Resultado: true (Inesperado)') ; writeln('  Resultado: false (Correcto: descartado por seguridad infantil)')).

% Caso 9: Prueba de recursividad sobre listas (Conteo y suma recursiva de factores de afinidad)
prueba_9 :-
    writeln('\n[CASO 9 - RECURSIVIDAD] Calculo recursivo de cuidados y puntaje de afinidad para Golden Retriever:'),
    cuidados_especificos(golden_retriever, Cuidados),
    contar_elementos(Cuidados, TotalCuidados),
    calcular_puntaje_afinidad([espacio_extra_holgado-8, excelente_con_ninos-5, tiempo_diario_adecuado-4], 70, PuntajeFinal),
    format('  Total cuidados (recursivo): ~w | Puntaje calculado (recursivo): ~w~n', [TotalCuidados, PuntajeFinal]).

% Caso 10: Prueba de diagnóstico de descarte (Explicabilidad de fallos lógicos para Border Collie en depto pequeño)
prueba_10 :-
    writeln('\n[CASO 10 - DIAGNOSTICO DE DESCARTE] ¿Por que se descarta un Border Collie para un principiante en depto pequeno con ninos pequenos?'),
    diagnosticar_descarte(departamento_pequeno, poco, no, pequenos, principiante, economico, perro, border_collie, Motivos),
    format('  Motivos inferidos: ~w~n', [Motivos]).

% Caso 11: Unificación y Backtracking directo sobre hechos de animales de refugio hipoalergénicos
prueba_11 :-
    writeln('\n[CASO 11 - UNIFICACION Y BACKTRACKING] Busqueda de todas las mascotas hipoalergenicas (Hipo = si):'),
    findall(ID-Especie, mascota(ID, _, Especie, _, _, _, _, _, si, _, _, _), ListaHipo),
    format('  Mascotas hipoalergenicas encontradas: ~w~n', [ListaHipo]).

% Caso 12: Comparación de jerarquía de espacio (Regla aritmética relacional)
prueba_12 :-
    writeln('\n[CASO 12 - JERARQUIA LOGICA] ¿Casa con patio cubre requerimiento de departamento amplio?'),
    (compatible_espacio(casa_con_patio, departamento_amplio) -> writeln('  Resultado: true (Nivel 3 >= Nivel 2)') ; writeln('  Resultado: false')).

mostrar_resumen([]) :-
    writeln('  -> Sin soluciones compatibles (false / lista vacia).').
mostrar_resumen(Lista) :-
    length(Lista, N),
    format('  -> Se encontraron ~w soluciones compatibles via backtracking:~n', [N]),
    forall(member(solucion(P, ID, Nombre, Nivel, _), Lista),
           format('     * [~w pts | ~w] ~w (~w)~n', [P, Nivel, Nombre, ID])).
