    typedef BOOST_DEDUCED_TYPENAME boost::conditional<
        boost::is_signed<no_cvr_prefinal_t>::value,
        boost::make_signed<no_cvr_prefinal_t>,
        boost::type_identity<no_cvr_prefinal_t>
    >::type no_cvr_prefinal_lazy_t;

