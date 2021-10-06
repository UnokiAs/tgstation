/datum/component/cybernetic_organ
	var/emp_shielded = FALSE

/datum/component/cybernetic_organ/Initialize(_emp_shielded = FALSE)
	if(!istype(parent, /obj/item/organ))
		return COMPONENT_INCOMPATIBLE

	var/obj/item/organ/parent_organ = parent
	parent_organ.organ_flags |= ORGAN_SYNTHETIC

	emp_shielded = _emp_shielded

	RegisterSignal(parent, COMSIG_ATOM_EMP_ACT, .proc/on_emp_act)

/datum/component/cybernetic_organ/Destroy(force, silent)
	var/obj/item/organ/parent_organ = parent
	parent_organ.organ_flags &= ~ORGAN_SYNTHETIC
	return ..(force, silent)

/datum/component/cybernetic_organ/proc/on_emp_act(datum/source, severity)
	SIGNAL_HANDLER

	if(emp_shielded)
		return
	parent.damage += 40/severity
