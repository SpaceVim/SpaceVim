local i = require('plenary.iterators')

dump(i.split("  hello person dude ", " "):tolist())
-- dump(("hello person"):find("person"))
