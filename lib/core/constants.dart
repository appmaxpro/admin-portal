
const int FLAG_PRIMARY = 0x1;
const int FLAG_UNIQUE = 0x2;
const int FLAG_REQUIRED = 0x4;
const int FLAG_INDEX = 0x8;
const int FLAG_READONLY = 0x16;
const int FLAG_TRANSIENT = 0x32;
const int FLAG_ENCRYPTED = 0x64;
const int FLAG_SEQUENCE = 0x128;
const int FLAG_VIRTUAL = 0x256;
const int FLAG_COPYABLE = 0x512;
const int FLAG_MASS_UPDATE = 0x1024;
const int FLAG_HIDDEN = 0x2048;
const int FLAG_NAME = 0x4096;
const int FLAG_JSON = FLAG_NAME * 2;
const int FLAG_IMAGE = FLAG_JSON * 2;
const int FLAG_TRANSLATE = FLAG_IMAGE * 2;
const int FLAG_ORPHAN = FLAG_TRANSLATE * 2;
const int FLAG_HASH = FLAG_ORPHAN * 2;
const int FLAG_SORTABLE = FLAG_HASH * 2;
const int FLAG_SEARCHABLE = FLAG_SORTABLE * 2;
const int FLAG_VERSION = FLAG_SEARCHABLE * 2;

enum FieldType{
  STRING,
  TEXT,
  INT,
  DOUBLE,
  BOOL,
  BINARY,
  DATE,
  DATE_TIME,
  M2O,
  O2M,
  M2M,
  ENUM
}
enum RelationType{
  M2O,
  O2M,
  M2M
}
