## From https://github.com/OpenSourceAP/CrossSection/blob/master/10_DownloadData.R

library(RPostgres)
if (!exists("wrds")) {
  wrds <- dbConnect(Postgres(),
                    host='wrds-pgdata.wharton.upenn.edu',
                    port=9737,
                    dbname='wrds',
                    user=rstudioapi::askForPassword("Database username"),
                    password=rstudioapi::askForPassword("Database password"),
                    sslmode='require')
}


numRowsToPull <- -1  # Set to -1 to get all data, set to positive value for testing

### List of data sets

res <- dbSendQuery(wrds, "select distinct table_schema
                   from information_schema.tables
                   where table_type ='VIEW'
                   or table_type ='FOREIGN TABLE'
                   order by table_schema")
data <- dbFetch(res, n=-1)
dbClearResult(res)
data

# CRSP monthly ------------------------------------------------------------

# Follows in part: https://wrds-www.wharton.upenn.edu/pages/support/research-wrds/macros/wrds-macro-crspmerge/
library(magrittr)
m_crsp = dbSendQuery(conn = wrds, statement = 
                       "select a.permno, a.permco, a.date, a.ret, a.retx, a.vol, a.shrout, a.prc, a.cfacshr, a.bidlo, a.askhi,
                     b.shrcd, b.exchcd, b.siccd, b.ticker, b.shrcls,  -- from identifying info table
                     c.dlstcd, c.dlret                                -- from delistings table
                     from crsp.msf as a
                     left join crsp.msenames as b
                     on a.permno=b.permno
                     and b.namedt<=a.date
                     and a.date<=b.nameendt
                     left join crsp.msedelist as c
                     on a.permno=c.permno 
                     and date_trunc('month', a.date) = date_trunc('month', c.dlstdt)
                     "
) %>% 
  # Pull data
  dbFetch(n = numRowsToPull)

data.table::fwrite(m_crsp, file = 'data/mCRSP.csv')
save(m_crsp, file = 'data/mCRSP.RData')

# CRSP Distributions ------------------------------------------------------
m_dist = dbSendQuery(conn = wrds, statement = 
                       "select d.permno, d.divamt, d.distcd, d.facshr, d.rcrddt
                     from crsp.msedist as d") %>% 
  dbFetch(n = numRowsToPull)

data.table::fwrite(m_dist, file = 'data/mCRSP.csv')
save(m_dist, file = 'data/mCRSP.RData')


# CRSP daily --------------------------------------------------------------

d_crsp = dbSendQuery(conn = wrds, statement = 
                       "select a.permno, a.date, a.ret, a.vol, a.shrout, a.prc, a.cfacshr
                     from crsp.dsf as a
                     "
) %>% 
  # Pull data
  dbFetch(n = numRowsToPull)

data.table::fwrite(d_crsp, file = 'data/mCRSP.csv')
save(d_crsp, file = 'data/mCRSP.RData')




