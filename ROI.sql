SELECT
    v.numero_pedido,
    v.clave_producto,
    p.nombre_producto,
    pc.clave_categoria,
    COALESCE(p.precio_producto, 0) AS precio_producto,
    COALESCE(v.cantidad_pedido, 0) AS cantidad_pedido,
    COALESCE(p.costo_producto, 0)  AS costo_producto,
    t.pais,
    t.continente,
    v.clave_territorio
FROM ventas_2017 v
INNER JOIN productos p
    ON v.clave_producto = p.clave_producto
INNER JOIN productos_categorias pc
    ON p.clave_subcategoria = pc.clave_subcategoria
INNER JOIN territorios t
    ON v.clave_territorio = t.clave_territorio; SELECT
    v.numero_pedido,
    v.clave_producto,
    p.nombre_producto,
    pc.clave_categoria,
    COALESCE(p.precio_producto, 0)                                   AS precio_producto,
    COALESCE(v.cantidad_pedido, 0)                                   AS cantidad_pedido,
    COALESCE(p.costo_producto, 0)                                    AS costo_producto,
    t.pais,
    t.continente,
    v.clave_territorio,
    COALESCE(p.precio_producto, 0) * COALESCE(v.cantidad_pedido, 0) AS ingreso_total,
    COALESCE(p.costo_producto, 0)  * COALESCE(v.cantidad_pedido, 0) AS costo_total
FROM ventas_2017 AS v
JOIN productos AS p
    ON v.clave_producto = p.clave_producto  SELECT
    pais,
    clave_territorio,
    SUM(ingreso_total)::integer AS ingresos,
    SUM(costo_total)::integer   AS costos
FROM ventas_clean
GROUP BY pais, clave_territorio
ORDER BY ingresos DESC;  SELECT
    v.pais,
    v.clave_territorio,
    SUM(v.ingreso_total)::bigint                        AS ingresos,
    SUM(v.costo_total)::bigint                          AS costos,
    COALESCE(SUM(c.costo_campana::numeric), 0)::bigint  AS costo_campana
FROM ventas_clean AS v
LEFT JOIN campanas AS c
    ON v.clave_territorio = c.clave_territorio::integer
GROUP BY
    v.pais,
    v.clave_territorio
ORDER BY
    ingresos DESC;  SELECT
    p.pais,
    p.clave_territorio,
    SUM(p.ingresos)::integer                                                                    AS ingresos,
    SUM(p.costos)::integer                                                                      AS costos,
    COALESCE(SUM(c.costo_campana), 0)::integer                                                  AS costo_campana,
    SUM(p.ingresos)::integer - SUM(p.costos)::integer                                           AS beneficio_bruto,
    (SUM(p.ingresos) - SUM(p.costos)) * 100.0 / NULLIF(SUM(p.ingresos), 0)                     AS margen_pct,
    (SUM(p.ingresos) - SUM(p.costos)) * 100.0 / NULLIF(COALESCE(SUM(c.costo_campana), 0), 0)   AS roi_pct
FROM pais_ingreso_costo AS p
LEFT JOIN pais_campanas AS c
    ON p.clave_territorio = c.clave_territorio
GROUP BY
    p.pais,
    p.clave_territorio
ORDER BY p.clave_territorio, ingresos, costos;   SELECT
    SUM(CASE WHEN numero_pedido   IS NULL THEN 1 ELSE 0 END) AS nulos_numero_pedido,
    SUM(CASE WHEN clave_producto  IS NULL THEN 1 ELSE 0 END) AS nulos_clave_producto,
    SUM(CASE WHEN clave_territorio IS NULL THEN 1 ELSE 0 END) AS nulos_clave_territorio
FROM ventas_2017; SELECT
    COUNT(*) AS filas_cantidad_no_valida
FROM ventas_2017
WHERE cantidad_pedido <= 0;  SELECT
    COUNT(*) AS productos_precio_no_valido
FROM productos
WHERE precio_producto < 0; 