class-pool .
*"* class pool for class Z_ABAPCLASS

*"* local type definitions
include Z_ABAPCLASS===================ccdef.

*"* class Z_ABAPCLASS definition
*"* public declarations
  include Z_ABAPCLASS===================cu.
*"* protected declarations
  include Z_ABAPCLASS===================co.
*"* private declarations
  include Z_ABAPCLASS===================ci.
endclass. "Z_ABAPCLASS definition

*"* macro definitions
include Z_ABAPCLASS===================ccmac.
*"* local class implementation
include Z_ABAPCLASS===================ccimp.

*"* test class
include Z_ABAPCLASS===================ccau.

class Z_ABAPCLASS implementation.
*"* method's implementations
  include methods.
endclass. "Z_ABAPCLASS implementation
