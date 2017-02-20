with utc_dates as (
  select '20120101 22:30:00' t -- winter time in London = UTC = 22:00
  from dual union all
  select '20120601 22:30:00'  -- summer time in London is UTC advanced by 1 hour, so London time = 23:30
  from dual 
)
  SELECT 
         to_timestamp(t, 'yyyymmdd hh24:mi:ss' ) t,
         from_tz(   to_timestamp(t, 'yyyymmdd hh24:mi:ss' ),  '+0:00' ) tz_utc,
         from_tz(   to_timestamp(t, 'yyyymmdd hh24:mi:ss' ),  '+0:00' ) at time zone 'Europe/London' london_time,
		 TZ_OFFSET(SESSIONTIMEZONE)
  from utc_dates
;


