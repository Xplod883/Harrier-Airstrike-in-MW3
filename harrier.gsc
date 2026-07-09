isjuggernautweapon( weapon )
{
    return false;
}
    
init()
{
    level.killstreakfuncs["airstrike"] = ::tryUseHarrierStrike;
    level.killstreakfuncs["precision_airstrike"] = ::tryUseHarrierStrike;
}
    tryUseHarrierStrike( lifeId )
{
    self endon( "disconnect" );
    self endon( "death" );
    self thread harrierCleanupOnEnd();

if ( !maps\mp\_utility::validateusestreak() )
    return 0;

if ( isDefined( level.civilianjetflyby ) )
{
    self iPrintLnBold( &"MP_CIVILIAN_AIR_TRAFFIC" );
    return 0;
}

if ( maps\mp\_utility::isusingremote() )
    return 0;

var_2 = level.mapsize / 6.46875;

if ( level.splitscreen )
    var_2 *= 1.5;

maps\mp\_utility::_beginlocationselection( "airstrike", "map_artillery_selector", 0, var_2 );

self endon( "stop_location_selection" );
self waittill( "confirm_location", location, directionYaw );

directionYaw = randomint( 360 );

self setblurforplayer( 0, 0.3 );

thread maps\mp\killstreaks\_airstrike::finishairstrikeusage(
    lifeId,
    location,
    directionYaw,
    "harrier_airstrike"
);

self notify( "harrier_strike_complete" );
return 1;
}
    harrierCleanupOnEnd()
{

self.harrierCleanupPending = true;
self thread harrierWatchEvent( "death" );
self thread harrierWatchEvent( "disconnect" );
self thread harrierWatchEvent( "harrier_strike_complete" );
}

harrierWatchEvent( eventName )
{
    self waittill( eventName );
    if ( !isDefined( self.harrierCleanupPending ) || !self.harrierCleanupPending )
return;

self.harrierCleanupPending = false;

if ( maps\mp\_utility::isusingremote() )
    self maps\mp\_utility::clearusingremote();
}
