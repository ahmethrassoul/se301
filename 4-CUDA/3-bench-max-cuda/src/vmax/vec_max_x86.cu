/*
*	Optimized byte interleaving functions - Copyright (c) 2021 Bertrand LE GAL
*
*  This software is provided 'as-is', without any express or
*  implied warranty. In no event will the authors be held
*  liable for any damages arising from the use of this software.
*
*  Permission is granted to anyone to use this software for any purpose,
*  including commercial applications, and to alter it and redistribute
*  it freely, subject to the following restrictions:
*
*  1. The origin of this software must not be misrepresented;
*  you must not claim that you wrote the original software.
*  If you use this software in a product, an acknowledgment
*  in the product documentation would be appreciated but
*  is not required.
*
*  2. Altered source versions must be plainly marked as such,
*  and must not be misrepresented as being the original software.
*
*  3. This notice may not be removed or altered from any
*  source distribution.
*
*/

#include "vec_max_x86.hpp"
#include <cfloat>
#include <climits>
#include <cstdint>
#include <cmath>
#include <algorithm>
/*
 *
 *
 *##############################################################################
 *
 *
 */
float vec_max_x86(
        const float* __restrict src,
        const int               length)
{
    float maxv = -FLT_MAX;
    for (int i = 0; i < length; i+= 1)
    {
        maxv = std::fmax(src[i], maxv);
    }
    return maxv;
};
/*
 *
 *
 *##############################################################################
 *
 *
 */
float vec_max_omp(
        const float* __restrict src,
        const int               length)
{
    float maxv = -FLT_MAX;
#pragma omp parallel
    {
        float priv_maxv = -FLT_MAX;

#pragma omp for
        for (int i = 0; i < length; i+= 1)
        {
            priv_maxv = std::fmax(src[i], priv_maxv);
        }

#pragma omp critical 
        {
            maxv = std::fmax(maxv, priv_maxv);
        }
    }
    return maxv;
};
/*
 *
 *
 *##############################################################################
 *
 *
 */
float vec_max_x86_novect(
        const float* __restrict src,
        const int32_t length)
{
    float maxv = -FLT_MAX;
#if defined (__clang__)
    #pragma clang loop vectorize(disable)
#endif
    for (int i = 0; i < length; i+= 1)
    {
        maxv = std::fmax(src[i], maxv);
    }
    return maxv;
};
/*
 *
 *
 *##############################################################################
 *
 *
 */
