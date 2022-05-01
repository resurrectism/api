Fabricator(:exercise) do
  name 'Exercise'
  track { Fabricate(:track) }
end
