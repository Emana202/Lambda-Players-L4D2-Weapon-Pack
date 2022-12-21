local IsValid = IsValid
local CurTime = CurTime
local random = math.random
local Rand = math.Rand
local DamageInfo = DamageInfo
local CreateSound = CreateSound
local trLine = util.TraceLine
local trHull = util.TraceHull
local trTbl = { mask = MASK_SHOT_HULL, mins = Vector( -4, -4, -2 ), maxs = Vector( 4, 4, 2 ) }

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_chainsaw = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_chainsaw.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Chainsaw",
        holdtype = "physgun",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_chainsaw",
        ismelee = true,
        keepdistance = 10,
        attackrange = 70,
        bonemerge = true,
        islethal = true,

        OnThink = function( self, wepent )
            if CurTime() > wepent.AttackTime then
                wepent.IsDeploying = false
                if wepent.IdleSound and !wepent.IdleSound:IsPlaying() then wepent.IdleSound:PlayEx( 0.5, 100 ) end
                if wepent.AttackSound and wepent.AttackSound:IsPlaying() then wepent.AttackSound:Stop() end
            end

            if !wepent.IsDeploying then
                if !self:IsPlayingGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2 ) then
                    local shakeLayer = self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2, true )
                    self:SetLayerPlaybackRate( shakeLayer, 2.0 ); self:SetLayerBlendOut( shakeLayer, 2.0 )
                end

                if CurTime() <= wepent.AttackTime then 
                    if wepent.IdleSound and wepent.IdleSound:IsPlaying() then wepent.IdleSound:Stop() end
                    if wepent.AttackSound and !wepent.AttackSound:IsPlaying() then wepent.AttackSound:Play() end

                    local attackLayer = self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM, true )
                    self:SetLayerCycle( attackLayer, 0.2 ) self:SetLayerBlendOut( attackLayer, 1.25 )

                    local fireSrc = self:GetAttachmentPoint( "eyes" ).Pos
                    local enemy = self:GetEnemy()
                    local fireDir = ( LambdaIsValid( enemy ) and ( enemy:WorldSpaceCenter() - fireSrc ):Angle() or self:GetAngles() )

                    trTbl.start = fireSrc
                    trTbl.endpos = ( fireSrc + fireDir:Forward() * 56 )
                    trTbl.filter = { self, wepent }
                    local tr = trLine( trTbl )
                    if !LambdaIsValid( tr.Entity ) then tr = trHull( trTbl ) end

                    local hitEnt = tr.Entity
                    if tr.Hit and IsValid( hitEnt ) then
                        local dmginfo = DamageInfo()
                        dmginfo:SetDamage( 2 )
                        dmginfo:SetDamageType( DMG_SLASH )
                        dmginfo:SetDamagePosition( tr.HitPos )
                        dmginfo:SetDamageForce( fireDir:Forward() * 2000 - fireDir:Up() * 2000)
                        dmginfo:SetInflictor( wepent )
                        dmginfo:SetAttacker( self )
                        hitEnt:DispatchTraceAttack( dmginfo, tr )
                    end
                end
            end
        end,

        OnEquip = function( self, wepent )
            self.l_WeaponUseCooldown = CurTime() + 2.5
            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_0" .. random( 1, 2 ) .. ".mp3", 80, nil, 0.66 )

            local layerID = self:AddGestureSequence( self:LookupSequence( "reload_revolver_base_layer" ), true )
            self:SetLayerCycle( layerID, 0.25 ); self:SetLayerBlendOut( layerID, 0.25 )

            wepent.IsDeploying = true
            wepent.AttackTime = CurTime() + 2.5

            wepent.IdleSound = CreateSound( wepent, "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_idle_lp_01.mp3" )
            wepent.AttackSound = CreateSound( wepent, "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_high_speed_lp_01.mp3" )

            wepent:CallOnRemove( "LambdaChainsaw_KillSounds" .. wepent:EntIndex(), function() 
                wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_die_01.mp3", 70 )
                wepent:StopSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_01.mp3" )
                wepent:StopSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_02.mp3" )

                if wepent.IdleSound then wepent.IdleSound:Stop(); wepent.IdleSound = nil end
                if wepent.AttackSound then wepent.AttackSound:Stop(); wepent.AttackSound = nil end 
            end )

            wepent:LambdaHookTick( "LambdaChainsaw_SoundThink", function() 
                if !IsValid( self ) then return true end
                if !self:GetIsDead() then return end

                if wepent.IdleSound and wepent.IdleSound:IsPlaying() then wepent.IdleSound:Stop() end
                if wepent.AttackSound and wepent.AttackSound:IsPlaying() then wepent.AttackSound:Stop() end 
            end )
        end,

        OnUnequip = function( self, wepent )
            wepent.IsDeploying = nil
            wepent.AttackTime = nil

            wepent:RemoveCallOnRemove( "LambdaChainsaw_KillSounds" .. wepent:EntIndex() )

            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_die_01.mp3", 70 )
            wepent:StopSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_01.mp3" )
            wepent:StopSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_02.mp3" )

            if wepent.IdleSound then wepent.IdleSound:Stop(); wepent.IdleSound = nil end
            if wepent.AttackSound then wepent.AttackSound:Stop(); wepent.AttackSound = nil end 
        end,

        OnDamage = function( self, wepent, dmginfo ) dmginfo:ScaleDamage( ( CurTime() <= wepent.AttackTime ) and 0.5 or 0.8 ) end,
        callback = function( self, wepent, target ) wepent.AttackTime = CurTime() + Rand( 0.33, 0.66 ) return true end
    }
} )