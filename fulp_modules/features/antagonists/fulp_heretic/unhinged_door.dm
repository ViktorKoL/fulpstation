/datum/component/spirit_holding/unhinged_door
	//aaaaa

/datum/component/spirit_holding/unhinged_door/Initialize()
	. = ..()

	if(!istype(parent,/obj/machinery/door))
		return COMPONENT_INCOMPATIBLE

/datum/component/spirit_holding/unhinged_door/RegisterWithParent()
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_destroy))

/datum/component/spirit_holding/unhinged_door/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_QDELETING))

//this is the parent proc copied because I could not figure out how to do the changes while inheriting...
/datum/component/spirit_holding/unhinged_door/affix_spirit(mob/awakener, mob/dead/observer/ghost)
	var/atom/thing = parent

	if(isnull(ghost))
		thing.balloon_alert(awakener, "silence...")
		attempting_awakening = FALSE
		unsuccessful()
		return

	if(QDELETED(parent)) //if the thing that we're conjuring a spirit in has been destroyed, don't create a spirit
		to_chat(ghost, span_userdanger("The new vessel for your spirit has been destroyed! You remain an unbound ghost."))
		unsuccessful()
		return

	bound_spirit = new(parent)
	bound_spirit.ckey = ghost.ckey
	bound_spirit.fully_replace_character_name(null, "The spirit of [parent]")
	bound_spirit.status_flags |= GODMODE
	bound_spirit.copy_languages(awakener, LANGUAGE_MASTER)
	bound_spirit.get_language_holder().omnitongue = TRUE

	RegisterSignal(parent, COMSIG_ATOM_RELAYMOVE, PROC_REF(block_buckle_message))
	RegisterSignal(parent, COMSIG_BIBLE_SMACKED, PROC_REF(on_bible_smacked))

	attempting_awakening = FALSE
	REMOVE_TRAIT(parent,TRAIT_UNHINGED_SEARCHING,src)
	ADD_TRAIT(parent,TRAIT_UNHINGED,src)

	bound_spirit.mind.add_antag_datum(/datum/antagonist/unhinged_door)

/datum/component/spirit_holding/unhinged_door/proc/unsuccessful()
	REMOVE_TRAIT(parent,TRAIT_UNHINGED_SEARCHING,src)
	qdel(src)


// mostly copied from heretic_monster:
/datum/antagonist/unhinged_door
	name = "\improper Unhinged Door"
	roundend_category = "Heretics"
	antagpanel_category = ANTAG_GROUP_HORRORS
	antag_moodlet = /datum/mood_event/heretics
	job_rank = ROLE_HERETIC
	antag_hud_name = "heretic_beast"
	suicide_cry = "TO THE SHED WE GO!!!"
	show_in_antagpanel = FALSE
	/// Linked airlock
	var/obj/machinery/door/body

/datum/antagonist/unhinged_door/on_gain()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ecult_op.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)//subject to change

	var/datum/objective/door_obj = new()
	door_obj.owner = owner
	door_obj.explanation_text = pick(world.file2list("fulp_modules/features/antagonists/fulp_heretic/unhinged_objectives.txt"))
	door_obj.completed = TRUE

	objectives += door_obj
	owner.announce_objectives()
	to_chat(owner, span_boldnotice("You are an airlock given a mind through the gates of the Shed."))
	to_chat(owner, span_notice("You do not have to assist the one who brought you here, but know they can banish you at will."))

	. = ..()
