{#-- Macro to get the final standard column names --#}
{#-- Input : Type of data that column will hold and description of the column --#}

{% macro getColumnnName(typ, col_desc) %}
    {#-- Replacing  specical character e.g. $Last-Year" ==> Last Year --#}
    {% set col_desc_updt = modules.re.sub('[\.\(\)\-\_\:\,\/\s]+', ' ', col_desc) %}
    {% set col_desc_updt = modules.re.sub('[\"\'\'\$]+', '', col_desc_updt) %} 

	{#-- Replace group of words with one abbreviation e.g Last year ==> [LYR] --#}
    {% set col_desc_updt = ReplaceMultiPartAcym(col_desc_updt) %}

	{#-- Create a list by splitting the above updated desc on spaces e.g. [LYR] Balance Due ==> [ [LYR], BALANCE, DUE ] --#}
    {% set col_desc_ele_lst = modules.re.split(' ', col_desc_updt) %}

	{#-- Get the prefix based on input (user selected type), e.g. Number ==> N --#}
	{% set pre_usr = GetPrefix(typ | upper) %}
    
	{#-- Stores prefix based on column desc part--#}
	{% set ns_1 = namespace(pre = 'T') %}

	{#-- Stores abbreviated string --#}
    {% set ns_2 = namespace(abbr_str = '') %}
    
	{#-- Get the abbreviations for each word in desc and get the prefix based on the desc --#}
    {% for col_desc_ele in col_desc_ele_lst %}
        {% if (col_desc_ele | trim) | length > 0 %}

			{#-- stores a word from column desc --#}
            {% set col_desc_ele = col_desc_ele | trim | upper %}

			{#-- flag to check if abbrevitation is required --#}
			{% set abbr_req_flg = True %}

			{#-- stores individual abbrevitation --#}
			{% set ns_3 = namespace(abbr = '') %}
			
			{#-- Abbreviation is not required if word is 'FOR' or 'TO' --#}
			{% if col_desc_ele in ['FOR', 'TO'] %}
				{% set abbr_req_flg = False %}

			{#-- Removes '[' and ']' from abbreviations of multi-part words --#}
			{% elif col_desc_ele[0] == '[' %}
				{% set ns_3.abbr = modules.re.sub('[\[\]]', '', col_desc_ele) %}

			{#-- Derive the prefix based on the words in the column desc--#}
			{% else %}
				{% if col_desc_ele | length >= 3 %}
					{% if col_desc_ele in '~AMT~AMOUNT~' %}
						{% set ns_1.pre = 'A' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~NAMES~' %}
						{% set ns_1.pre = 'N' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~TIME~' %}
						{% set ns_1.pre = 'Z' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~CODE~' %}
						{% set ns_1.pre = 'C' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~DATE~' %}
						{% set ns_1.pre = 'D' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~FLAG~FLG~' %}
						{% set ns_1.pre = 'X' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~PREMIUMS~PRINCIPAL~INTERESTS~DISCOUNTS~DIVIDENTS~COSTS~FEES~TAXES~BALANCES~' %}
						{% set ns_1.pre = 'A' %}
						{% set abbr_req_flg = True %}
	
					{% elif col_desc_ele in '~QTY~QUANTITY~COUNT~' %}
						{% set ns_1.pre = 'Q' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~NO~#~NUMBERS~' %}
						{% set ns_1.pre = 'I' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~PCT~PERCENTAGE~PCNT~' %}
						{% set ns_1.pre = 'P' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~STARTED~FINISHED~' %}
						{% set ns_1.pre = 'Z' %}
						{% set abbr_req_flg = True %}
	
					{% elif col_desc_ele in '~TIMESTAMP~DATE~' %}
						{% set ns_1.pre = 'Z' %}
						{% set abbr_req_flg = False %}
	
					{% elif col_desc_ele in '~IDENTIFIER~' %}
						{% set ns_1.pre = 'I' %}
						{% set abbr_req_flg = True %}
	
					{% elif col_desc_ele in '~STATUS~' %}
						{% set ns_1.pre = 'C' %}
						{% set abbr_req_flg = True %}    
					{% endif%}
				{% endif %}
			{% endif %}

			{#-- Get the abbreviations if the flag is true --#}
			{% if abbr_req_flg %}

				{#-- Get the abbreviation from COMBINED_ABBREVIATION_LIST table --#}
				{% if not ns_3.abbr %}
					{% set ns_3.abbr = GetAbbreCombined(col_desc_ele) %}
				{% endif %}	

				{#-- Remove 'S' from the word (making it singular) and get the abbreviation from COMBINED_ABBREVIATION_LIST table --#}
				{% if not ns_3.abbr %}
					{% if col_desc_ele[-1] == 'S' and col_desc_ele | length > 3 %}
						{% set col_desc_ele = col_desc_ele[:-1]  %}
						{% set ns_3.abbr = GetAbbreCombined(col_desc_ele) %}
					{% endif %}
				{% endif %}

				{#-- Remove 'ES' from the word (making it singular) and get the abbreviation from COMBINED_ABBREVIATION_LIST table --#}
				{% if not ns_3.abbr %}
					{% if col_desc_ele[-2:] == 'ES' and col_desc_ele | length > 4 %}
						{% set col_desc_ele = col_desc_ele[:-2]  %}
						{% set ns_3.abbr = GetAbbreCombined(col_desc_ele) %}

					{% endif %}
				{% endif %}

				{#-- Create Abbreviation --#}
				{% if not ns_3.abbr %}
					{% set ns_3.abbr = FormAbbre(col_desc_ele) %}
				{% endif %}

				{#-- If abbreviation has ',', use the value before the ',' as abbreviation e.g. BUSINESS - BUSNS, BSNS --#}
				{% if ',' in ns_3.abbr %}
					{% set com_ind = ns_3.abbr.index(',') %}
					{% set ns_3.abbr = ns_3.abbr[:com_ind] %}
				{% endif %}

				{#-- Concatenate all abbreviations, seperating them by an '_' --#}
                {% if ns_3.abbr |length > 0 %}
                    {% set sep = '_' if ns_2.abbr_str | length > 0 else '' %}
                    {% set ns_2.abbr_str = ns_2.abbr_str + sep + (ns_3.abbr | upper) %}
                {% endif %}
			{% endif %}
        {% endif %}
    {% endfor %}
        
	{#-- Concatenate prefix with abbreviations --#}
    {% if not pre_usr %}
        {% set ns_2.abbr_str = ns_1.pre + '_' + ns_2.abbr_str %}
    {% else %}
        {% set ns_2.abbr_str = pre_usr + '_' + ns_2.abbr_str %}
    {% endif %}

	{#-- Returns the final column name --#}
    {{ return (ns_2.abbr_str)}}
{% endmacro %}

{# -------------------------------------------------------GetPrefix------------------------------------------------------------------- #}

{#-- Macro to return the prefix --#}
{#-- Input: Type of data --#}
{% macro GetPrefix(typ) %}

{#-- Query to get the prefix for given input --#}
{% set prefix_query %}
    select COL1,COL2 from(
        select distinct
            full_form AS COL1,
            abbreviation AS COL2
        from EDO_TRAINING_NP.MASTER.ST_FIELD_TYPE_PREFIX
    where UPPER(full_form) = UPPER('{{typ}}')) 
    where COL2 is not null
    --order by 1
{% endset %}

{#-- Get the column data in a list --#}
{% set prefix_lst = get_list_data(prefix_query, 2) %}

{#-- Returns the prefix --#}
{{return(prefix_lst[0])}}
{% endmacro %}

{# -------------------------------------------------GetAbbreCombined---------------------------------------------------------------- #}

{#-- Macro to return the abbreviation --#}
{#-- Input: one word from a column description --#}
{% macro GetAbbreCombined(col_nm) %}

{#-- Query to get the prefix for given input --#}
{% set abbreviation_query %}
    select distinct
          FULL_FORM,
          ABBREVIATION
    from EDO_TRAINING_NP.MASTER.ST_COMBINED_ABBREVIATION_LIST
    where FULL_FORM = '{{col_nm}}' 
    and ABBREVIATION is not NULL

{% endset %}

{#-- Get the column data in a list --#}
{% set abbr_lst = get_list_data(abbreviation_query, 2) %}

{#-- Returns the abbreviations --#}
{{return(abbr_lst[0])}}
{% endmacro %}

{# -----------------------------------------------------FormAbbre-------------------------------------------------------------------- #}

{#-- Macro to create a new abbreviation --#}
{#-- Input: one word from a column description --#}
{% macro FormAbbre(column_desc_ele) %}
    {% set col_desc_ele = column_desc_ele | upper %}

    {#-- If the input word is 'FOR' or 'IS' returns no abbreviation #}
    {% if col_desc_ele in ['FOR', 'IS'] %}
        {{ return ('') }}
    {% endif %}

    {#-- Return input as is  if its length is <= 3 --#}
    {% if col_desc_ele | length <= 3 %}
        {{ return(col_desc_ele) }}
    {% endif %}

    {#-- Remove vowels from the second letter to last letter. --#}
    {% set col_desc_no_vwl = modules.re.sub('[AEIOU]+', '', col_desc_ele[1:]) %}

    {# --Remove duplicate letters --#}
    {% set abbr_ns = namespace(abr = col_desc_ele[0]) %}
    {% for ltr in col_desc_no_vwl %}
        {% if ltr != abbr_ns.abr[-1]%}
            {% set abbr_ns.abr = abbr_ns.abr + ltr %}
        {% endif %}
    {% endfor %}

    {#-- returns the abbreviations --#}
    {{ return(abbr_ns.abr) }}
{% endmacro %}

{# ---------------------------------------------------ReplaceMultiPartAcym-------------------------------------------------------- #}

{#-- Macro to replace group of words with one abbreviations --#}
{#-- Input: Column description --#}
{% macro ReplaceMultiPartAcym(col_desc) %}
    {% set column_desc = col_desc | upper %}

    {#-- Get the Column description with group words replaced with their respective abbreviations --#}
    {% set abbr_col = get_abbr_frm_list(column_desc, 'EDO_TRAINING_NP.MASTER.ST_COMBINED_ABBREVIATION_LIST') | trim %}
     
    {#-- Stores input as it is if there is not abbreviations for group of words in column description    --#}
    {% if not abbr_col %}
        {% set abbr_col = column_desc %}
    {% endif %}

    {#-- Returns the updated column description --#}
    {{ return(abbr_col) }}
{% endmacro %}


{#-- Returns the Column description with group words replaced with their respective abbreviations --#}
{% macro get_abbr_frm_list(column_desc, tbl) %}
    
    {#-- Store the SQL query --#}
    {% set query %}
    select * from {{ tbl }}
    {% endset %}

    {#-- Get the full form and abbreviation in seperate lists --#}
    {% set column_nm_lst = get_list_data(query) %}
    {% set abbr_nm_lst = get_list_data(query, 2) %}
    {% for col_nm, abbr_nm in zip(column_nm_lst,abbr_nm_lst) %}

        {#-- Store full form and its abbreviation from the table --#}
        {% set lst_col = modules.re.sub('-', ' ', col_nm) | upper %}
        {% set lst_abbr = (abbr_nm | trim) | upper %}

        {#-- if full form contains space and it is present in column description replace it with its abbreviations enclosed in '[]' --#}
        {% if ' ' in lst_col %}
            {% if lst_col in column_desc %}
                {{ return( modules.re.sub(lst_col, '['+lst_abbr+']', column_desc) ) }}
            {% endif %}
        {% endif %}
    {% endfor %}
{% endmacro %} 


---------------------------------------------------------------------------------------------------
{#-- Returns the entire column data in a list --#}
{% macro get_list_data(query, col_num = 1) %}

    {#-- Execute the query --#}
    {% set results = run_query(query) %}

    {#-- Get the entire column data in a list --#}
    {% set column_lst = [] %}
    {% if execute %}
        {% set column_lst = results.columns[col_num-1].values() %}
    {% endif %}

    {#-- Return the list of data --#}
    {{ return(column_lst) }}
{% endmacro %}