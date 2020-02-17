# memory_profiler (ruby 2.3.8+)
# allocated - total memory allocated during profiler run
# retained - survived after MemoryProfiler finished

# require_relative 'bad_work.rb'
require_relative 'work.rb'
require 'benchmark'
require 'memory_profiler'

report = MemoryProfiler.report do
  work('data20000.txt', disable_gc: false)
end
report.pretty_print(scale_bytes: true)
