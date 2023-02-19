local IsValid = IsValid
local ipairs = ipairs
local EffectData = EffectData
local util_Effect = util.Effect
local random = math.random
local coroutine_wait = coroutine.wait

local fireDamageTbl = { 8, 10 }
local fireRateTbl = { 0.8, 1.2 }
local deploySnds = { { 0, "lambdaplayers/weapons/l4d2/shotgun_chrome/gunother/shotgun_deploy_1.mp3" } }

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_shotgun_chrome = {
        model = "models/lambdaplayers/weapons/l4d2/w_shotgun_chrome.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Chrome Shotgun",
        holdtype = "shotgun",
        killicon = "lambdaplayers/killicons/icon_l4d2_shotgun_chrome",
        bonemerge = true,

        clip = 8,
        islethal = true,
        attackrange = 1000,
        keepdistance = 400,

        OnReload = function( self, wepent )
            self:RemoveGesture( ACT_HL2MP_GESTURE_RELOAD_AR2 )
            local reloadLayer = self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_AR2, true )

            self:SetIsReloading( true )
            self:Thread( function()

                coroutine_wait( 0.45 )
                
                while ( self.l_Clip < self.l_MaxClip ) do
                    local ene = self:GetEnemy()
                    if self.l_Clip > 0 and random( 1, 2 ) == 1 and self:InCombat() and self:IsInRange( ene, 512 ) and self:CanSee( ene ) then break end

                    if !self:IsValidLayer( reloadLayer ) then
                        reloadLayer = self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_AR2, true )
                    end
                    self:SetLayerCycle( reloadLayer, 0.3 )
                    self:SetLayerPlaybackRate( reloadLayer, 1.33 ) 

                    self.l_Clip = self.l_Clip + 1
                    wepent:EmitSound( "lambdaplayers/weapons/l4d2/shotgun_chrome/gunother/shotgun_load_shell_" .. random( 1, 2 ) .. ".mp3", 65, 100, 1, CHAN_ITEM )
                    coroutine_wait( 0.475 )
                end

                coroutine_wait( 0.5 )

                self:RemoveGesture( ACT_HL2MP_GESTURE_RELOAD_AR2 )
                self:SetIsReloading( false )
            
            end, "L4D2_ShotgunReload" )

            return true
        end,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Damage = fireDamageTbl
            wepent.L4D2Data.Spread = 0.125
            wepent.L4D2Data.Sound = "lambdaplayers/weapons/l4d2/shotgun_chrome/gunfire/shotgun_fire_1.mp3"
            wepent.L4D2Data.RateOfFire = fireRateTbl
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
            wepent.L4D2Data.EjectShell = false
            wepent.L4D2Data.Pellets = 8
            wepent.L4D2Data.CrouchedSpreadScale = 0.9
            wepent.L4D2Data.DeploySound = deploySnds

            LAMBDA_L4D2:InitializeWeapon( self, wepent )
        end,

        callback = function( self, wepent, target )
            if LAMBDA_L4D2:FireWeapon( self, wepent, target ) != true then
                self:SimpleTimer( 0.45, function()
                    if self:GetWeaponName() != "l4d2_shotgun_chrome" or !IsValid( wepent ) then return end
                    wepent:EmitSound( "lambdaplayers/weapons/l4d2/shotgun_chrome/gunother/shotgun_pump_1.mp3", 70, 100, 1, CHAN_ITEM )

                    local shellData = wepent:GetAttachment( wepent:LookupAttachment( "shell" ) )
                    local effectData = EffectData()
                    effectData:SetEntity( wepent )
                    effectData:SetOrigin( shellData.Pos )
                    effectData:SetAngles( shellData.Ang )
                    util_Effect( "ShotgunShellEject", effectData )
                end )
            end

            return true
        end
    }
} )