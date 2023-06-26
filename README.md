![diag-dark](./db/diag-dark.png)

## Installation

```bash
git clone [https://github.com/jmpleo/flight-scheduler.git|http://gitlab.com/1193221/flight-scheduler.git]
cd flight-scheduler
```

### 1. Init Database

``` bash
cd db
./init.sh
```

### 2. Fill Database

```bash
python fill-db.py [flight_count] [schedule_count]
```