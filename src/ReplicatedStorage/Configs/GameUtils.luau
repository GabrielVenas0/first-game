local GameConfig = require(script.Parent.GameConfig)

local Public = {}

function Public.getToolProperties(toolId: string): GameConfig.ToolProperties?
	local toolProps = GameConfig.Tools.Axes[toolId]
	if toolProps then
		return toolProps
	end

	toolProps = GameConfig.Tools.Pickaxes[toolId]
	if toolProps then
		return toolProps
	end

	return nil
end

function Public.getNodeProperties(nodeId: string): GameConfig.NodeProperties?
	local nodeProps = GameConfig.Nodes.Trees[nodeId]
	if nodeProps then
		return nodeProps
	end

	nodeProps = GameConfig.Nodes.Ores[nodeId]
	if nodeProps then
		return nodeProps
	end

	return nil
end

function Public.getItemProperties(itemId: string): GameConfig.ItemProperties?
	return GameConfig.Items[itemId]
end

return Public