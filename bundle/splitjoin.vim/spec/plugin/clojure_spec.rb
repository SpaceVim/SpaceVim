require 'spec_helper'

describe "clojure" do
  let(:filename) { 'test.clj' }

  specify "Lists with ([ brackets" do
    set_file_contents "(dispatch [::events/insert-staff-entry day-ord shift unit @why @who])"

    vim.search 'dispatch'
    split

    assert_file_contents <<~EOF
      (dispatch
        [::events/insert-staff-entry day-ord shift unit @why @who])
    EOF

    join

    assert_file_contents <<~EOF
      (dispatch [::events/insert-staff-entry day-ord shift unit @why @who])
    EOF

    vim.search 'day-ord'
    split

    assert_file_contents <<~EOF
      (dispatch [::events/insert-staff-entry
                 day-ord
                 shift
                 unit
                 @why
                 @who])
    EOF

    join

    assert_file_contents <<~EOF
      (dispatch [::events/insert-staff-entry day-ord shift unit @why @who])
    EOF
  end

  specify "Dictionaries" do
    set_file_contents '#{:a :b :c :d}'

    vim.search ':b'
    split

    assert_file_contents <<~'EOF'
      #{:a
        :b
        :c
        :d}
    EOF

    join

    assert_file_contents '#{:a :b :c :d}'
  end

  specify "Doesn't get confused with brackets in strings" do
    set_file_contents '(map (fn [x] (.toUpperCase x)) (.split "Dasher Dancer) Prancer" " "))'

    vim.search 'Dancer'
    split

    assert_file_contents <<~EOF
      (map (fn [x] (.toUpperCase x)) (.split
                                       "Dasher Dancer) Prancer"
                                       " "))
    EOF

    join

    assert_file_contents '(map (fn [x] (.toUpperCase x)) (.split "Dasher Dancer) Prancer" " "))'
  end
end
