passion.timer = {}

------------------------------------
-- PUBLIC FUNCTIONS
------------------------------------

function passion.timer.after(seconds, f, ...)

  return passion.timer.Timer:new(seconds, f, ...)

end


function passion.timer.every(seconds, f, ...)

  return passion.timer.PeriodicTimer:new(seconds, f, ...)

end

function passion.timer.update()
  passion.timer.Timer:update()
end