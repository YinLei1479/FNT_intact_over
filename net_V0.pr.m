MIL_3_Tfile_Hdr_ 145A 140A modeler 9 6690DD76 66961888 17 ray-laptop 28918 0 0 none none 0 0 none D6F30803 1A6E 0 0 0 0 0 0 1bcc 1                                                                                                                                                                                                                                                                                                                                                                                              ��g�      @   D   H      u  J  N  R  V  b  f  j  i           	   begsim intrpt         
   ����   
   doc file            	nd_module      endsim intrpt             ����      failure intrpts            disabled      intrpt interval         ԲI�%��}����      priority              ����      recovery intrpts            disabled      subqueue                     count    ���   
   ����   
      list   	���   
          
      super priority             ����             &/* neighbor address + neighbor slot */   int	\my_neighbor[24][2];       /* my node address */   int	\my_address;       /* number of neighbor */   /*                    */   int	\nei_count;       /* my node slot */   int	\my_slot;       Objid	\my_id;       Objid	\my_node_id;       /* rcv pk type */   
int	\type;       /* two hop neibor number */   int	\my_two_nei_count_sum;       /* two hop neighbor address */   int	\my_two_nei[24];       !/* receive QWZ id in this slot */   int	\now_slot_id[24];       int	\now_slot_QWZ_num;          int i,j;   Packet* pkptr;   int t_c;   int nei[8];          #include <math.h>       /* Constant Definitions */   #define RX_IN		(0)   #define SRC_IN		(1)   #define TX_OUT		(0)   #define SINK_OUT	(1)               "/* Transition Condition Macros */    Z#define FROM_RX_PK			(op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm () == RX_IN)   \#define FROM_SRC_PK 		(op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm () == SRC_IN)       .   -/*static void QWZ_rcv(Packet* pkptr)//QWZ_RCV   	{   	int nei_id;   	int nei_slot;   	int nei_in_flag;   	int two_nei_num;   	int two_nei_id[8];   	//int two_nei_in_flag;   	//int count_in;   	int i;   	   	FIN(QWZ_rcv(Packet* pkptr));   +	op_pk_nfd_get (pkptr, "Address", &nei_id);   *	op_pk_nfd_get (pkptr, "Slot", &nei_slot);   	nei_in_flag=0;   +	if(my_neighbor[nei_id][0]==0) nei_count++;   	my_neighbor[nei_id][0]=1;   !	my_neighbor[nei_id][1]=nei_slot;   	//����ھӱ�����ռ��ʱ϶   	   	   0	op_pk_nfd_get (pkptr, "Nei_num", &two_nei_num);   8	op_pk_nfd_get (pkptr, "Nei_address_0", &two_nei_id[0]);   8	op_pk_nfd_get (pkptr, "Nei_address_1", &two_nei_id[1]);   8	op_pk_nfd_get (pkptr, "Nei_address_2", &two_nei_id[2]);   8	op_pk_nfd_get (pkptr, "Nei_address_3", &two_nei_id[3]);   8	op_pk_nfd_get (pkptr, "Nei_address_4", &two_nei_id[4]);   8	op_pk_nfd_get (pkptr, "Nei_address_5", &two_nei_id[5]);   8	op_pk_nfd_get (pkptr, "Nei_address_6", &two_nei_id[6]);   8	op_pk_nfd_get (pkptr, "Nei_address_7", &two_nei_id[7]);   	for(i=0;i<two_nei_num;i++)   		{   :		if(my_two_nei[two_nei_id[i]]==0) my_two_nei_count_sum++;   		my_two_nei[two_nei_id[i]]=1;   		}   	//��������ھӽڵ��ռ�   	   	now_slot_id[nei_id]=1;   4	now_slot_QWZ_num++;//�ռ���֡��QWZ��Ŀ�뷢��QWZ��ַ   	   	FOUT;   	}   	*/   	   	   		                                          Z   �          
   init   
       
      //initial begin   my_id = op_id_self();   $my_node_id = op_topo_parent (my_id);       6op_ima_obj_attr_get(my_node_id,"Address",&my_address);       my_slot = my_address;   nei_count=0;   for(i=0;i<24;i++)   )	for(j=0;j<2;j++) my_neighbor[i][j]=0xFF;   my_two_nei_count_sum=0;   %for(i=0;i<24;i++) my_two_nei[i]=0xFF;   &for(i=0;i<24;i++) now_slot_id[i]=0xFF;   now_slot_QWZ_num=0;           .printf("$$$$$$$$$$$$net over$$$$$$$$$$$$$\n");   
                     
   ����   
          pr_state           �          
   idle   
                                       ����             pr_state        �   Z          
   rx_rcv   
       
      //�յ���ͬ���Ͱ�����Ϊ   "pkptr=op_pk_get(op_intrpt_strm());   %op_pk_nfd_get (pkptr, "TYPE", &type);   if(type==0)//QWZ   	{   	//QWZ_rcv(pkptr);   	op_pk_send(pkptr,SINK_OUT);   	}   
                     
   ����   
          pr_state        �            
   src_rcv   
       J   &   /*   pkptr =  op_pk_get (SRC_IN);   %op_pk_nfd_get (pkptr, "TYPE", &type);       if(type==0)//QWZ   	{   -	op_pk_nfd_set (pkptr, "Nei_num", nei_count);   (	op_pk_nfd_set (pkptr, "Slot", my_slot);   	t_c=0;   	for(i=0;i<24;i++) nei[i]=0xFF;   	for(i=0;i<24;i++)   		{   		if(my_neighbor[i][0]==1)   			{   			nei[t_c]=i;   				t_c++;   			}   		}   0	op_pk_nfd_set (pkptr, "Nei_address_0", nei[0]);   0	op_pk_nfd_set (pkptr, "Nei_address_1", nei[1]);   0	op_pk_nfd_set (pkptr, "Nei_address_2", nei[2]);   0	op_pk_nfd_set (pkptr, "Nei_address_3", nei[3]);   0	op_pk_nfd_set (pkptr, "Nei_address_4", nei[4]);   0	op_pk_nfd_set (pkptr, "Nei_address_5", nei[5]);   0	op_pk_nfd_set (pkptr, "Nei_address_6", nei[6]);   6	op_pk_nfd_set (pkptr, "Nei_address_7", nei[7]);//װ��   	   '	op_pk_send(pkptr,TX_OUT);//send to mac   	   )	printf("%d	QWZ pk send to mac\n",my_id);   	   	for(i=0;i<24;i++)   *		for(j=0;j<2;j++) my_neighbor[i][j]=0xFF;   	nei_count=0;   	my_two_nei_count_sum=0;   4	for(i=0;i<24;i++) my_two_nei[i]=0xFF;//һ֡���һ��   	}   */   J                     
   ����   
          pr_state                        �   �      g   �   �   �          
   tr_0   
       ����          ����          
    ����   
          ����                       pr_transition               �   �         �   �   �   �   �     �          
   tr_1   
       
   default   
       ����          
    ����   
          ����                       pr_transition              E   �        �  u   h          
   tr_3   
       
   
FROM_RX_PK   
       ����          
    ����   
          ����                       pr_transition              R   �     �   j     �          
   tr_5   
       ����          ����          
    ����   
          ����                       pr_transition              a   �        �  x   �          
   tr_6   
       
   FROM_SRC_PK   
       ����          
    ����   
          ����                       pr_transition              Z   �     t       �          
   tr_7   
       
����   
       ����          
    ����   
          ����                       pr_transition                                             