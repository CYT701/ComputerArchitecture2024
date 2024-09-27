#include <stdio.h>

/*int findComplement(int num) {
    //convert num to binary and store in array
    int binaryarr[31] = {0};
    int end = 0;//the end of binary string
    for(int i=0 ; i<31 ; i++){
        if(num == 1)
			break;
        binaryarr[i] = num % 2;
        num = num / 2;
        end++;
    }
    binaryarr[end] = 1;
    for(int i=0 ; i<31 ; i++){
        if(binaryarr[i] == 1){
            binaryarr[i] = 0;
        }
        else if(binaryarr[i] == 0){
            binaryarr[i] = 1;
        }
    }
    int square = 1;
    int ans = 0;
    for(int i=0 ; i<end ; i++){
        ans = ans + binaryarr[i]*square;
        square = square << 1;
    }
    return ans;
}*/

/*int findComplement(int num) {
    //use XOR
    unsigned int mask = 1;
    while(mask <= num){
        mask = mask << 1;
    }
    mask = mask - 1;
    return mask ^ num;
}*/

int findComplement(int num) {
    //use __builtin_clz
    return num ^ ((1U << (sizeof(num) * 8 - __builtin_clz(num))) - 1);
}
int main(){
	int num1 = 5;
	printf("The complement of %d is %d\n",num1, findComplement(num1));
	int num2 = 1;
	printf("The complement of %d is %d\n",num2, findComplement(num2));
	int num3 = 2147483647;
	printf("The complement of %d is %d\n",num3, findComplement(num3));
	return 0;
}

