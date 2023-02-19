local IsValid = IsValid
local ipairs = ipairs
local random = math.random
local coroutine_wait = coroutine.wait

local fireDamageTbl = { 8, 10 }
local fireRateTbl = { 0.3, 0.5 }
local deploySnds = {
    { 0, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_deploy_1.mp3" },
    { 0.33, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_boltback.mp3" },
    { 0.66, "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_boltforward.mp3" }
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_shotgun_spas = {
        model = "models/lambdaplayers/weapons/l4d2/w_shotgun_spas.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Combat Shotgun",
        holdtype = "shotgun",
        killicon = "lambdaplayers/killicons/icon_l4d2_shotgun_spas",
        bonemerge = true,

        clip = 10,
        islethal = true,
        attackrange = 1000,
        keepdistance = 400,

        OnReload = function( self, wepent )
            self:RemoveGesture( ACT_HL2MP_GESTURE_RELOAD_AR2 )
            local reloadLayer = self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_AR2, true )

            self:SetIsReloading( true )
            self:Thread( function()

                coroutine_wait( 0.466 )
                
                local interruptEne = false
                while ( self.l_Clip < self.l_MaxClip ) do
                    interruptEne = ( self.l_Clip > 0 and random( 1, 2 ) == 1 and self:InCombat() and self:IsInRange( self:GetEnemy(), 512 ) and self:CanSee( self:GetEnemy() ) )
                    if interruptEne then break end 

                    if !self:IsValidLayer( reloadLayer ) then
                        reloadLayer = self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_AR2, true )
                    end
                    self:SetLayerCycle( reloadLayer, 0.3 )
                    self:SetLayerPlaybackRate( reloadLayer, 1.33 ) 

                    self.l_Clip = self.l_Clip + 1
                    wepent:EmitSound( "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/auto_shotgun_load_shell_" .. random( 1, 2 ) .. ".mp3", 65, 100, 1, CHAN_ITEM )
                    coroutine_wait( 0.4 )
                end

                if !interruptEne then
                    wepent:EmitSound( "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_boltback.mp3", 65, 100, 1, CHAN_ITEM )
                    self:SimpleTimer( 0.25, function() wepent:EmitSound( "lambdaplayers/weapons/l4d2/shotgun_spas/gunother/autoshotgun_boltforward.mp3", 65, 100, 1, CHAN_ITEM ) end )
                    coroutine_wait( 0.6 )
                end

                self:RemoveGesture( ACT_HL2MP_GESTURE_RELOAD_AR2 )
                self:SetIsReloading( false )
            
            end, "L4D2_ShotgunReload" )

            return true
        end,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.125
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/shotgun_spas/gunfire/auto_shotgun_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = fireRateTbl
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
            wepent.L4D2Data.EjectShell = "ShotgunShellEject"
            wepent.L4D2Data.Pellets = 9
            wepent.L4D2Data.CrouchedSpreadScale = 0.9
            wepent.L4D2Data.DeploySound = deploySnds

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )