local dataHandler = { data = {}, attachments = {} };

function dataHandler:Set(key, data)
	self.data[key] = data;

	if self.attachments[key] then
		for _, func in pairs(self.attachments[key]) do
			func(data);
		end;
	end;

	return data;
end;

function dataHandler:Get(key)
	local data = self.data[key];
	if data == nil or data == "" then
		data = self.plugin:GetSetting(key);
		
		self.data[key] = data;
	end;

	return data;
end;

function dataHandler:AttachChange(key, func)
	if not self.attachments[key] then self.attachments[key] = {} end;
	
	table.insert(self.attachments[key], func);
end;

function dataHandler:Save()
	for key, value in pairs(self.data) do
		self.plugin:SetSetting(key, value);
	end;
	
	return dataHandler;
end;

function dataHandler:ProvidePlugin(plugin)
	self.plugin = plugin;
	
	plugin.Unloading:Connect(function()
		self:Save();
	end);
	
	return self;
end;

return dataHandler;
