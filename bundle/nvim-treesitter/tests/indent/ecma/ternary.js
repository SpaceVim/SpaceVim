const value =
  condition
    ? typeof number === 'string'
      ? Number(number)
      : number
    : null;
