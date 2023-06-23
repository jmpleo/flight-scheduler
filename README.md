![diag-dark](./db/diag-dark.png)

## Installation

```bash
git clone https://github.com/jmpleo/flight-scheduler.git
cd flight-scheduler
```

### 1. Create Database

``` bash
cd db
psql -f create-db.sql
```

### 2. Fill Database

```bash
python fill-db.py [flight_count] [schedule_count]
```