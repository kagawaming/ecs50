#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int editDist(char* word1, char* word2);
int min(int a, int b);

int min(int a, int b){
  return a < b ? a:b;
}
int editDist(char* word1, char* word2){

  int word1_len = strlen(word1);
  int word2_len = strlen(word2);
  int a[100][100];

  int i,j,dist,d;
  for (i=0;i<word1_len+1;i++){
    a[i][0]=i;
  }
  for (j=0;j<word2_len+1;j++){
    a[0][j]=j;
  }
  for (i=1;i<word1_len+1;i++){
    for (j=1;j<word2_len+1;j++){
      if(word1[i-1]== word2[j-1]){
        d=a[i-1][j-1];
      }
      else{
        d=a[i-1][j-1]+1;
      }
      a[i][j]=min(min(a[i-1][j]+1,a[i][j-1]+1),d);
    }
  }
  dist = a[i-1][j-1];
  for(i=0;i<word1_len+1;i++){
    for(j=0;j<word2_len+1;j++){
      printf("%d ",a[i][j]);
    }
    printf("\n");
  }
  return dist;
  }

int main(int argc, char** argv){
  if(argc < 3){
    printf("Usage: %s word1 word 2\n", argv[0]);
    exit(1);
  }
  printf("The distance between %s and %s is %d.\n", argv[1], argv[2], editDist(argv[1], argv[2]));

  return 0;
}
