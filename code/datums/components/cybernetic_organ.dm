/**
 * Component that makes an organ take damage when struct by an EMP
 */
/datum/component/cybernetic_organ
	var/emp_shielded = FALSE

/datum/component/cybernetic_organ/Initialize()
	if(!istype(parent, /obj/item/organ))
		return COMPONENT_INCOMPATIBLE

	var/obj/item/organ/parent_organ = parent
	parent_organ.organ_flags |= ORGAN_SYNTHETIC
	emp_shielded = parent_organ & EMP_PROTECT_SELF

/datum/component/cybernetic_organ/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_EMP_ACT, .proc/on_emp_act)

/datum/component/cybernetic_organ/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_ATOM_EMP_ACT)

/datum/component/cybernetic_organ/Destroy(force, silent)
	var/obj/item/organ/parent_organ = parent
	parent_organ.organ_flags &= ~ORGAN_SYNTHETIC
	return ..(force, silent)

/datum/component/cybernetic_organ/proc/on_emp_act(datum/source, severity)
	SIGNAL_HANDLER
	if(emp_shielded)
		return
	var/obj/item/organ/parent_organ = parent
	parent_organ.damage += 40/severity
