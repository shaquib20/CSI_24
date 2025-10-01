def three_sum_sorted(nums):
    """
    Find all unique triplets in a sorted array that sum to zero.
    
    Args:
        nums: List of integers (assumed to be sorted)
    
    Returns:
        List of lists containing unique triplets that sum to zero
    """
    if len(nums) < 3:
        return []
    
    result = []
    n = len(nums)
    
    for i in range(n - 2):
        # Skip duplicates for the first element
        if i > 0 and nums[i] == nums[i - 1]:
            continue
        
        # Two pointers approach for the remaining two elements
        left = i + 1
        right = n - 1
        target = -nums[i]  # We want nums[i] + nums[left] + nums[right] = 0
        
        while left < right:
            current_sum = nums[left] + nums[right]
            
            if current_sum == target:
                # Found a valid triplet
                result.append([nums[i], nums[left], nums[right]])
                
                # Skip duplicates for the second element
                while left < right and nums[left] == nums[left + 1]:
                    left += 1
                
                # Skip duplicates for the third element
                while left < right and nums[right] == nums[right - 1]:
                    right -= 1
                
                left += 1
                right -= 1
                
            elif current_sum < target:
                left += 1
            else:
                right -= 1
    
    return result


def three_sum_unsorted(nums):
    """
    Find all unique triplets in an unsorted array that sum to zero.
    First sorts the array, then uses the sorted approach.
    
    Args:
        nums: List of integers (may be unsorted)
    
    Returns:
        List of lists containing unique triplets that sum to zero
    """
    return three_sum_sorted(sorted(nums))


def demo_three_sum():
    """Demonstrate the 3Sum algorithm with various test cases."""
    print("3Sum Algorithm Demo")
    print("=" * 50)
    
    test_cases = [
        [-1, 0, 1, 2, -1, -4],
        [0, 1, 1],
        [0, 0, 0],
        [-2, 0, 1, 1, 2],
        [-4, -1, -1, 0, 1, 2],
        [1, 2, 3, 4, 5],
        []
    ]
    
    for i, nums in enumerate(test_cases, 1):
        print(f"\nTest Case {i}: {nums}")
        
        if nums:
            sorted_nums = sorted(nums)
            print(f"Sorted: {sorted_nums}")
            result = three_sum_sorted(sorted_nums)
        else:
            result = three_sum_sorted(nums)
        
        if result:
            print(f"Triplets that sum to zero: {result}")
        else:
            print("No triplets found that sum to zero")


if __name__ == "__main__":
    demo_three_sum()