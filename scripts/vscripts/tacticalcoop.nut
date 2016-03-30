MutationOptions <-
{
  CommonLimit = 200 // Maximum number of common zombies alive in the world at the same time
 	MegaMobSize = 20  // Total number of common zombies in a mob. (never more than CommonLimit at one time)
 	WanderingZombieDensityModifier = 0 // lets get rid of the wandering zombies
 	MaxSpecials  = 0 // 
 	TankLimit    = 1 // 
 	WitchLimit   = 1 // 
	BoomerLimit  = 1
 	ChargerLimit = 1
 	HunterLimit  = 1
	JockeyLimit  = 1
	SpitterLimit = 1
	SmokerLimit  = 1
  
  cm_BaseCommonAttackDamage = 12.5
}

//MutationState <-
//{
//	CurrentStage = 0
//}

// previous flow value at which we spawned horde 
flow_prev <- 0.0

// we spawn hordes using this flow step
flow_step <- 0.01 // 3% of flow 

// at this flow value we will start a very big horde
flow_mega_mob <- RandomFloat(0.2, 0.7)  
num_waves_mega_mob <- RandomInt( 3, 5 )
waves_spawned_mega_mob <- 0

//
flow_SI_step <- 0.2
flow_SI_prev <- 0

director_ent <- Entities.FindByClassname (null, "info_director");

//function GetNextStage()
//{
//  printl( "GetNextStage()" )
//}

function Update()
{
  //printl( "Update()" )
  
  local furthestflow = GetAverageSurvivorFlowDistance();
  local maxflow = GetMaxFlowDistance();
  local flow_current = furthestflow / maxflow;
  //printl( furthestflow +" : " + maxflow + " : " + flow_current + " : " + flow_prev )
  if ( flow_current > (flow_prev + flow_step) && 
       ( (0 == waves_spawned_mega_mob) || (waves_spawned_mega_mob >= num_waves_mega_mob ) ) ) // skip regular waves when in mega_mob
  {
    while( flow_current > (flow_prev + flow_step) )
    {
      SessionOptions.MegaMobSize = RandomInt(4, 7)
      flow_prev = flow_prev + flow_step
      DoEntFire("!self","ForcePanicEvent","0",0,null,director_ent); 
      printl("Spawning horde, size: " + SessionOptions.MegaMobSize )
    }    
  }
  
  if ( flow_current > flow_mega_mob && waves_spawned_mega_mob < num_waves_mega_mob )
  {
    waves_spawned_mega_mob++
    SessionOptions.MegaMobSize = 20
    DoEntFire("!self","ForcePanicEvent","0",0,null,director_ent); 
    //printl("Spawning mega horde, wave" + waves_spawned_mega_mob)
  }
  
  if ( flow_current > ( flow_SI_prev + flow_SI_step ))
  {
    // spawn a SI 
    flow_SI_prev = flow_SI_prev + flow_SI_step
    SessionOptions.MaxSpecials = 1
    Director.ResetSpecialTimers()
    //printl("Spawning SI")
  }
  else
  {
    SessionOptions.MaxSpecials = 0
  }
}