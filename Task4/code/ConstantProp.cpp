#include "../../include/ir/opt/ConstantProp.hpp"
#include <cmath>
#include <set>

bool ConstantProp::Run() {
  /*
  要求：
  1. 顺序遍历function中的每个基本块,并顺序遍历基本块中的每个指令
  2. 如果一个指令是常量传播的结果，那么就将这个指令替换为常量，并删除这个指令
  */
 for(auto bb:(*_func))//遍历每个基本块
  {
    for(auto inst:(*bb))//遍历每个指令
    {
      bool flag = true;
      for(auto &use:inst->Getuselist())
      {
        if(!use->GetValue()->isConst())
        {
          flag = false;
          break;
        }
      }
      if(flag)
      {
        auto val = ConstFoldInst(inst);
        if(val)
        {
        inst->RAUW(val);
        inst->EraseFromParent();
        }
      }
    }
  }
  return true;
}

Value *ConstantProp::ConstFoldInst(User *inst) {
  /*
  要求：
  1. 考虑一条指令是否能进行常量折叠
  2. 如果能够进行常量折叠，那么返回折叠后的常量
  3. 正确判断指令的类型，对于不同的类型需要有不同的处理方法
  这个过程可以自行在 ConstantProp类中增加函数来实现功能
  */
  if(inst->IsBinary())
  {
    auto op1 = inst->GetOperand(0);
    auto op2 = inst->GetOperand(1);
    auto op1_val = dynamic_cast<ConstantData*>(op1);
    auto op2_val = dynamic_cast<ConstantData*>(op2);
    if(op1_val->GetType()->GetTypeEnum() == InnerDataType::IR_Value_INT)
    {
      auto op1_int = dynamic_cast<ConstIRInt*>(op1_val);
      auto op2_int = dynamic_cast<ConstIRInt*>(op2_val);
      switch(inst->GetInstId())
      {
        case User::OpID::Add:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() + op2_int->GetVal());
        case User::OpID::Sub:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() - op2_int->GetVal());
        case User::OpID::Mul:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() * op2_int->GetVal());
        case User::OpID::Div:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() / op2_int->GetVal());
        case User::OpID::Mod:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() % op2_int->GetVal());
        case User::OpID::And:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() & op2_int->GetVal());
        case User::OpID::Or:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() | op2_int->GetVal());
        case User::OpID::Xor:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() ^ op2_int->GetVal());
        case User::OpID::Eq:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() == op2_int->GetVal());
        case User::OpID::Ne:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() != op2_int->GetVal());
        case User::OpID::Ge:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() >= op2_int->GetVal());
        case User::OpID::L:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() < op2_int->GetVal());
        case User::OpID::Le:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() <= op2_int->GetVal());
        case User::OpID::G:
          return ConstIRInt::GetNewConstant(op1_int->GetVal() > op2_int->GetVal());
      }
    }
    else if(op1_val->GetType()->GetTypeEnum() == InnerDataType::IR_Value_Float)
    {
      auto op1_float = dynamic_cast<ConstIRFloat*>(op1_val);
      auto op2_float = dynamic_cast<ConstIRFloat*>(op2_val);
      switch(inst->GetInstId())
      {
        case User::OpID::Add:
          return ConstIRFloat::GetNewConstant(op1_float->GetVal() + op2_float->GetVal());
        case User::OpID::Sub:
          return ConstIRFloat::GetNewConstant(op1_float->GetVal() - op2_float->GetVal());
        case User::OpID::Mul:
          return ConstIRFloat::GetNewConstant(op1_float->GetVal() * op2_float->GetVal());
        case User::OpID::Div:
          return ConstIRFloat::GetNewConstant(op1_float->GetVal() / op2_float->GetVal());
        case User::OpID::Eq:
          return ConstIRInt::GetNewConstant(op1_float->GetVal() == op2_float->GetVal());
        case User::OpID::Ne:
          return ConstIRInt::GetNewConstant(op1_float->GetVal() != op2_float->GetVal());
        case User::OpID::Ge:
          return ConstIRInt::GetNewConstant(op1_float->GetVal() >= op2_float->GetVal());
        case User::OpID::L:
          return ConstIRInt::GetNewConstant(op1_float->GetVal() < op2_float->GetVal());
        case User::OpID::Le:
          return ConstIRInt::GetNewConstant(op1_float->GetVal() <= op2_float->GetVal());
        case User::OpID::G:
          return ConstIRInt::GetNewConstant(op1_float->GetVal() > op2_float->GetVal());
      }
    }
  }
  return nullptr;
}
