SELECT
    product_name,
    category,
    performance_score,
    shelf_width_inches,
    ROUND(
        (shelf_width_inches::decimal /
        (SELECT total_width_inches FROM shelf_constraints LIMIT 1)) * 100,
    2) AS shelf_space_percent
FROM (
    WITH ranked_products AS (
    SELECT
        *,
        weekly_sales * profit_margin AS performance_score
    FROM products
    WHERE active = TRUE
),
ordered_products AS (
    SELECT
        *,
        SUM(shelf_width_inches) OVER (
            ORDER BY performance_score DESC
        ) AS cumulative_width
    FROM ranked_products
)
SELECT *
FROM ordered_products
WHERE cumulative_width <= (
    SELECT total_width_inches FROM shelf_constraints LIMIT 1
)

) AS optimized
ORDER BY performance_score DESC;
