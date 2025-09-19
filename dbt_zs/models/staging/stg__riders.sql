with source as (
    select * from {{ source("raw", "riders") }}
),

most_recent_load as (
    select * from source
),

column_selection as (
    select 
        rider_id::int as id,
        name::varchar as rider,
        gender::varchar as gender,
        country::varchar as country,
        age::varchar as age_class,
        height::int as height,
        weight::float as weight,
        zp_category::varchar as zwift_category,
        zp_ftp::float as ftp,
        power__wkg5::float as wkg_5,
        power__wkg15::float as wkg_15,
        power__wkg30::float as wkg_30,
        power__wkg60::float as wkg_60,
        power__wkg120::float as wkg_120,
        power__wkg300::float as wkg_300,
        power__wkg1200::float as wkg_1200,
        power__w5::float as watts_5,
        power__w15::float as watts_15,
        power__w30::float as watts_30,
        power__w60::float as watts_60,
        power__w120::float as watts_120,
        power__w300::float as watts_300,
        power__w1200::float as watts_1200,
        race__current__rating::float as rating_current,
        race__max30__rating::float as rating_max_30_day,
        race__max90__rating::float as rating_max_90_day,
        race__current__mixed__category::varchar as category_current,
        race__max30__mixed__category::varchar as category_best_30_day,
        race__max90__mixed__category::varchar as category_best_90_day,
        race__finishes::int as race_finishes,
        race__podiums::int as race_podiums,
        race__wins::int as race_wins,
        handicaps__profile__flat::float as handicap_flat,
        handicaps__profile__rolling::float as handicap_rolling,
        handicaps__profile__hilly::float as handicap_hilly,
        handicaps__profile__mountainous::float as handicap_mountainous,


    from most_recent_load
)

select * from column_selection