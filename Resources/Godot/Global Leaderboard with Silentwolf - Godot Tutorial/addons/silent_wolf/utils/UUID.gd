static func get_random_int(max_value: int) -> int:
	randomize()
	return randi() % max_value

static func random_bytes(n: int) -> Array:
	var r = []
	for index in range(0, n):
		r.append(get_random_int(256))
	return r

static func uuid_bin() -> Array:
	var b = random_bytes(16)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return b

static func generate_uuid_v4() -> String:
	var b = uuid_bin()
	var low = "%02x%02x%02x%02x" % [b[0], b[1], b[2], b[3]]
	var mid = "%02x%02x" % [b[4], b[5]]
	var hi = "%02x%02x" % [b[6], b[7]]
	var clock = "%02x%02x" % [b[8], b[9]]
	var node = "%02x%02x%02x%02x%02x%02x" % [b[10], b[11], b[12], b[13], b[14], b[15]]
	return "%s-%s-%s-%s-%s" % [low, mid, hi, clock, node]

static func is_uuid(test_string: String) -> bool:
	return test_string.count("-") == 4 and test_string.length() == 36


# MIT License

# Copyright (c) 2018 Xavier Sellier

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# Changes made:
# - Refactored variable names and function signatures to follow snake case naming convention
# - Added type hints to all variables and function attributes
