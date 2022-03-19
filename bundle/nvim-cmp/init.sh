DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm $DIR/.git/hooks/*
cp $DIR/.githooks/* $DIR/.git/hooks/
chmod 755 $DIR/.git/hooks/*


