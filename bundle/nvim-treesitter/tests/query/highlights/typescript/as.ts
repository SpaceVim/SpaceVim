import * as foo from 'foo';
//       ^ include

export { foo as bar };
//           ^ include

const n = 5 as number;
//          ^ keyword.operator
