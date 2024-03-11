class Foo {

    Foo(int a, int b, int c, int d)
        : m_a(a)
        , m_b(b)
        , m_c(c)
        , m_d(d) {}

    Foo(int a, int b, int c) :
        m_a(a),
        m_b(b),
        m_c(c)
    {}

    int m_a, m_b, m_c, m_d;
};

