require "cli/ui"

CLI::UI::StdoutRouter.enable
CLI::UI::Frame.open('Frame 1') do
  CLI::UI::Frame.open('Frame 2') { puts "inside frame 2" }
  puts "inside frame 1"
end
