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
ORDER BY performance_score DESC;
