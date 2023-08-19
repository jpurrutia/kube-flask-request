from app import get_data


def test_get_data():
    assert type(get_data("2023-08-11")) == dict
