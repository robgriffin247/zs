with 
source as (
    select *
    from {{ ref("stg__riders") }}
),

add_columns as (
    select 
        *,        
        watts_ftp/weight as wkg_ftp,
        race_dnfs + race_finishes as race_starts,
        strftime(to_timestamp(dlt_load_epoch), '%Y-%m-%d %H:%M:%S') as dlt_load_datetime,
    from source
),

column_selection as (
    select
        id,
        rider,
        club_id,
        club,
        weight,
        zwift_category,
        velo_current,
        velo_current_category,
        velo_max_90,
        velo_max_90_category,
        race_starts,
        race_finishes,
        race_wins,
        race_podiums,
        wkg_5,
        wkg_15,
        wkg_30,
        wkg_60,
        wkg_120,
        wkg_300,
        wkg_1200,
        wkg_ftp,
        watts_5,
        watts_15,
        watts_30,
        watts_60,
        watts_120,
        watts_300,
        watts_1200,
        watts_ftp,
        handicap_flat,
        handicap_rolling,
        handicap_hilly,
        handicap_mountainous,
        phenotype_sprinter,
        phenotype_puncheur,
        phenotype_pursuiter,
        phenotype_climber,
        phenotype_timetrialist,
        dlt_load_datetime,
        dlt_load_epoch,
    from add_columns
)

select * from column_selection