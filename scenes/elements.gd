enum Elements {NONE, NATURE, MACHINE, WASTE}

static func is_stronger_element(e1, e2):
	if e1 == NATURE and e2 == WASTE:
		return true
	if e1 == MACHINE and e2 == NATURE:
		return true
	if e1 == WASTE and e2 == MACHINE:
		return true
	return false
