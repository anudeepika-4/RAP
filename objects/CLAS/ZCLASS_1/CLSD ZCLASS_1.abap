class-pool .
*"* class pool for class ZCLASS_1

*"* local type definitions
include ZCLASS_1======================ccdef.

*"* class ZCLASS_1 definition
*"* public declarations
  include ZCLASS_1======================cu.
*"* protected declarations
  include ZCLASS_1======================co.
*"* private declarations
  include ZCLASS_1======================ci.
endclass. "ZCLASS_1 definition

*"* macro definitions
include ZCLASS_1======================ccmac.
*"* local class implementation
include ZCLASS_1======================ccimp.

*"* test class
include ZCLASS_1======================ccau.

class ZCLASS_1 implementation.
*"* method's implementations
  include methods.
endclass. "ZCLASS_1 implementation
