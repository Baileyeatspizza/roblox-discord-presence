local DRPC = script:FindFirstAncestor("DRPC");
local Assets = DRPC.assets;
local Text = game:GetService("TextService");

local Data = require(DRPC.src.dataHandler);
local UI = {};

function UI:ProvidePlugin(plugin)
	self.plugin = plugin;
end;

function UI:Start()
	if not self.plugin then return end;
	
	local settingsGui = self.plugin:CreateDockWidgetPluginGui("settingsGui", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false));
	
	Assets.Container:Clone().Parent = settingsGui;
	settingsGui.Title   = "DRPC Settings";
	settingsGui.Enabled = true;

	print(settingsGui)

	-- Resize Controller Init.
	require(DRPC.src.UIManager.resizeController):Init(settingsGui);
	local toggleController = require(DRPC.src.UIManager.toggleController):Init(settingsGui.Container.Enable.Container.Switch);

	local descriptionEditor = settingsGui.Container.DescriptionInput.Input;
	descriptionEditor.Text = Data:Get("Description") or "$ACTIVITY:Editing $SCRIPT_NAME ($SCRIPT_LINES Lines)";
	descriptionEditor.FocusLost:Connect(function()
		Data:Set("Description", descriptionEditor.Text);
	end);
	
	local statusEditor = settingsGui.Container.StateInput.Input;
	statusEditor.Text = Data:Get("State") or "Workspace: $WORKSPACE";
	statusEditor.FocusLost:Connect(function()
		Data:Set("State", statusEditor.Text);
	end);
	
	local savedButtons = Data:Get("Buttons") or {};
	local button1 = settingsGui.Container.Button1;
	local button2 = settingsGui.Container.Button2;
	button1.Second.Input.Text = savedButtons[1] and savedButtons[1].label or "";
	button2.Second.Input.Text = savedButtons[2] and savedButtons[2].label or "";
	button1.First.Input.Text = savedButtons[1] and savedButtons[1].url or "";
	button2.First.Input.Text = savedButtons[2] and savedButtons[2].url or "";

	local function setLabel(i, prop, value)
		if not savedButtons[i] then
			savedButtons[i] = {};
		end;
		savedButtons[i][prop] = value;
		Data:Set("Buttons", savedButtons);
	end;
	
	button1.Second.Input.FocusLost:Connect(function() setLabel(1, "label", button1.Second.Input.Text) end);
	button2.Second.Input.FocusLost:Connect(function() setLabel(2, "label", button2.Second.Input.Text) end);
	button1.First.Input.FocusLost:Connect(function() setLabel(1, "url", button1.First.Input.Text) end);
	button2.First.Input.FocusLost:Connect(function() setLabel(2, "url", button2.First.Input.Text) end);

	local infoVersion = settingsGui.Container.Info.Version;
	infoVersion.Text = "v0.2.0-alpha";

	print("Finished.")
end;

return UI;