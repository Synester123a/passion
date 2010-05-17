
-----------------------------------------------------------------------------------
-- Beholder.lua
-- Enrique García ( enrique.garcia.cota [AT] gmail [DOT] com ) - 4 Mar 2010
-- Small framework for event observers
-----------------------------------------------------------------------------------

assert(Object~=nil and class~=nil, 'MiddleClass not detected. Please require it before using MindState')

-- Private variable storing the list of event callbacks that can be used
local _events = {}

-- The Beholder module
Beholder = {}

function Beholder:observe(eventId, methodOrName, ...)

  assert(self~=nil, "self is nil. invoke object:observe instead of object.observe")

  _events[eventId] = _events[eventId] or {}
  local event = _events[eventId]

  event[self] = event[self] or setmetatable({}, {__mode = "k"})
  local eventsForSelf = event[self]

  eventsForSelf[methodOrName] = eventsForSelf[methodOrName] or {}
  local actions = eventsForSelf[methodOrName]

  table.insert(actions, {method = methodOrName, params = {...} })
end

function Beholder:stopObserving(eventId, methodOrName)
  local event = _events[eventId]
  if(event==nil) then return end

  local eventsForSelf = event[self]
  if(eventsForSelf==nil) then return end

  if(methodOrName~=nil) then
    eventsForSelf[methodOrName] = nil
  else
    event[self] = setmetatable({}, {__mode = "k"})
  end
end


--[[ Triggers events
   Usage:
     Beholder.trigger('passion.update', dt)
   All objects that are "observing" passion.update events will get their associated actions called.
]]

function Beholder.trigger(eventId, ...)

  local event = _events[eventId]
  if(event==nil) then return end
  
  for object,eventsForObject in pairs(event) do
    for _,actions in pairs(eventsForObject) do
      for _,action in ipairs(actions) do
        local method = action.method
        if(type(method)=='string') then
          method = object[method]
        end
        assert(type(method)=='function', 'Action must be a function or method name. Was ' .. tostring(method))
        local params = {}
        for k,v in ipairs(action.params) do params[k] = v end
        for _,v in ipairs({...}) do table.insert(params, v) end
        method(object, unpack(params))
      end
    end
  end
end
