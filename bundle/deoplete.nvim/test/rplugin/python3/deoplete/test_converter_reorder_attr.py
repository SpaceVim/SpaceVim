from deoplete.filter.converter_reorder_attr import Filter

candidates = [
    {'word': 'Apple', 'kind': 'Fruit'},
    {'word': 'Banana', 'kind': 'Fruit'},
    {'word': 'Pen', 'kind': 'Object'},
    {'word': 'Cherry Pie', 'kind': 'Pie'},
]


def test_reorder():
    candidates_copy = candidates[:]

    preferred_order = {'kind': ['Pie', 'Fruit']}

    expected_candidates = [
        {'word': 'Cherry Pie', 'kind': 'Pie'},
        {'word': 'Apple', 'kind': 'Fruit'},
        {'word': 'Banana', 'kind': 'Fruit'},
        {'word': 'Pen', 'kind': 'Object'},
    ]

    assert expected_candidates == Filter.filter_attrs(
        candidates_copy, preferred_order
    )


def test_filter():
    candidates_copy = candidates[:]

    preferred_order = {'word': ['!Pen', 'Banana']}

    expected_candidates = [
        {'word': 'Banana', 'kind': 'Fruit'},
        {'word': 'Apple', 'kind': 'Fruit'},
        {'word': 'Cherry Pie', 'kind': 'Pie'},
    ]

    assert expected_candidates == Filter.filter_attrs(
        candidates_copy, preferred_order
    )
