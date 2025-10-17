with source as (
    select * from {{ source("raw", "riders") }}
),

most_recent_load as (
    select 
        rider_id, 
        max(_dlt_load_id) as _dlt_load_id,
        true as most_recent
    from source
    group by rider_id
),

filter_to_recent as (
    select
        source.*
    from source left join most_recent_load using(rider_id, _dlt_load_id)
    where most_recent=true
),

column_selection as (
    select 
        rider_id::int as id,
        name::varchar as rider,
        gender::varchar as gender,
        country::varchar as country_code,
        age::varchar as age_category,
        height::int as height,
        coalesce(weight, weight__v_double)::float as weight,
        zp_category::varchar as zwift_category,
        zp_ftp::float as watts_ftp, --coalesce(zp_ftp, power__zp_ftp)::float as watts_ftp,
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
        power__cp::float as watts_critical_power,
        power__awc::float as work_capacity, --coalesce(power__awc, power__awc__v_double)::float as work_capacity,
        power__compound_score::float as compound_score,
        power__power_rating::float as power_rating,
        race__last__rating::float as velo_last,
        race__last__date::int as velo_last_epoch,
        race__last__mixed__category::varchar as velo_last_mixed_category,
        race__last__mixed__number::int as velo_last_mixed_category_number,
        race__current__rating::float as velo_current,
        race__current__date::int as velo_current_epoch,
        race__current__mixed__category::varchar as velo_current_category,
        race__current__mixed__number::int as velo_current_category_number,
        race__max30__rating::float as velo_max_30,
        race__max30__date::int as velo_max_30_epoch,
        race__max30__expires::int as velo_max_30_expires_epoch,
        race__max30__mixed__category::varchar as velo_max_30_category,
        race__max30__mixed__number::int as velo_max_30_category_number,
        race__max90__rating::float as velo_max_90,
        race__max90__date::int as velo_max_90_epoch,
        race__max90__expires::int as velo_max_90_expires_epoch,
        race__max90__mixed__category::varchar as velo_max_90_category,
        race__max90__mixed__number::int as velo_max_90_category_number,
        race__finishes::int as race_finishes,
        race__dnfs::int as race_dnfs,
        race__wins::int as race_wins,
        race__podiums::int as race_podiums,
        handicaps__profile__flat::float as handicap_flat,
        handicaps__profile__rolling::float as handicap_rolling,
        handicaps__profile__hilly::float as handicap_hilly,
        handicaps__profile__mountainous::float as handicap_mountainous,
        phenotype__scores__sprinter::float as phenotype_sprinter,
        phenotype__scores__puncheur::float as phenotype_puncheur,
        phenotype__scores__pursuiter::float as phenotype_pursuiter,
        phenotype__scores__climber::float as phenotype_climber,
        phenotype__scores__tt::float as phenotype_timetrialist,
        phenotype__value::varchar as phenotype,
        phenotype__bias::float as phenotype_bias,
        club__id::int as club_id,
        club__name::varchar as club,
        _dlt_load_id::float as dlt_load_epoch,
        _dlt_id::varchar as dlt_load,
        race__last__womens__category::varchar as velo_last_womens_category,
        race__last__womens__number::int as velo_last_womens_category_number,
        race__current__womens__category::varchar as velo_current_womens_category,
        race__current__womens__number::int as velo_current_womens_category_number,
        race__max30__womens__category::varchar as velo_max_30_womens_category,
        race__max30__womens__number::int as velo_max_30_womens_category_number,
        race__max90__womens__category::varchar as velo_max_90_womens_category,
        race__max90__womens__number::int as velo_max_90_womens_category_number,
    from filter_to_recent
)

select * from column_selection