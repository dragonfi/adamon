
const elements = ["nature", "machine", "waste"]

static func is_stronger_element(e1, e2):
	if e1 == "nature" and e2 == "waste":
		return true
	if e1 == "machine" and e2 == "nature":
		return true
	if e1 == "waste" and e2 == "machine":
		return true
	return false
