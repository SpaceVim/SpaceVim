select
    id
from foo
where id < (
    select
        id
    from bar
    limit 1
);
