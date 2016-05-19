def test(s)
  p s
end

alias :original_test :test

def test(s)
  original_test s
end

test("11")