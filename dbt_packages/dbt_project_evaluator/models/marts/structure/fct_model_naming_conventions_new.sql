-- all models with inappropriate (or lack of) suf-fix
-- ensure dbt project has consistent naming conventions

with all_graph_resources as (
    select * from {{ ref('int_all_graph_resources') }}
),

naming_convention_suffixes as (
    select * from {{ ref('stg_naming_convention_suffixes') }}
), 

appropriate_suffixes as (
    select 
        model_type, 
        {{ dbt.listagg('suffix_value', "', '", 'order by suffix_value') }} as appropriate_suffixes
    from naming_convention_suffixes
    group by model_type
), 

models as (
    select
        all_graph_resources.resource_name,
        all_graph_resources.prefix,
        all_graph_resources.model_type,
        naming_convention_suffixes.suffix_value
    from all_graph_resources 
    left join naming_convention_suffixes
        on all_graph_resources.model_type = naming_convention_suffixes.model_type
        and all_graph_resources.prefix = naming_convention_suffixes.suffix_value
    where resource_type = 'model'
),

inappropriate_model_names as (
    select 
        models.resource_name,
        models.prefix,
        models.model_type,
        appropriate_suffixes.appropriate_suffixes
    from models
    left join appropriate_suffixes
        on models.model_type = appropriate_suffixes.model_type
    where models.suffix_value is null

)

select * from inappropriate_model_names

{{ filter_exceptions(this) }}