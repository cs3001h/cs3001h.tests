#include "datasheet.h"

#define SWAP(a,b) do { typeof(a) temp=(a);(a)=(b);(b)=temp; } while (0)
#define SWAP_IF_GREATER(a, b) do { if ((a) > (b)) SWAP(a, b); } while (0)
  
static void sort(int n, type arr[]);
static int verify(int n, const volatile int* test, const int* verify);

int main(int argc, char const *argv[])
{
  sort( DATA_SIZE, input_data );
  return verify( DATA_SIZE, input_data, verify_data );
}

static void sort(int n, type arr[])
{
  for (type* i = arr; i < arr+n-1; i++)
    for (type* j = i+1; j < arr+n; j++)
      SWAP_IF_GREATER(*i, *j);
}

static int verify(int n, const volatile int* test, const int* verify)
{
  for (int i = 0; i < n; i++)
  {
    int t = test[i];
    int v = verify[i];
    if (t != v) return i + 1;
  }
  return 0;
}
