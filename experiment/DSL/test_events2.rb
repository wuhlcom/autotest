setup do
  puts  "Setthing up sky2"
  @sky_height=100
end

setup  do
  puts "Setting up mountains2"
  @mountains_height=200
end

event "the sky is falling2" do
  @sky_height<300
end

event "it's getting closer2" do
  @sky_height<@mountains_height
end
