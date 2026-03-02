


for _, descendant in pairs(game:GetDescendants()) do
    if descendant:IsA("Part") or descendant:IsA("Union") or descendant:IsA("CornerWedgePart") or descendant:IsA("TrussPart") then
        -- 简化材质和反射率
        descendant.Material = "Plastic"
        descendant.Reflectance = 0
    elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
        -- 隐藏贴图
        descendant.Transparency = 1
    elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
        -- 禁用粒子效果
        descendant.Lifetime = NumberRange.new(0)
    elseif descendant:IsA("Explosion") then
        -- 削弱爆炸效果
        descendant.BlastPressure = 1
        descendant.BlastRadius = 1
    elseif descendant:IsA("Fire") or descendant:IsA("SpotLight") or descendant:IsA("Smoke") then
        -- 禁用火焰、聚光灯和烟雾
        descendant.Enabled = false
    end
end
